import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

Deno.serve(async (req) => {
  try {
    const { entree_id } = await req.json()

    if (!entree_id) {
      return new Response(
        JSON.stringify({ error: 'entree_id est requis' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } },
      )
    }

    // Client avec la clé service_role pour bypasser la RLS
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
    )

    // Compter les signalements distincts pour cette entrée
    // (la contrainte UNIQUE garantit 1 signalement max par user → count = nombre de reporters distincts)
    const { count, error: countError } = await supabase
      .from('signalements')
      .select('*', { count: 'exact', head: true })
      .eq('entree_id', entree_id)

    if (countError) {
      console.error('Erreur comptage signalements:', countError)
      return new Response(
        JSON.stringify({ error: 'Erreur lors du comptage des signalements' }),
        { status: 500, headers: { 'Content-Type': 'application/json' } },
      )
    }

    const nombreSignalements = count ?? 0
    const doitRestreindre = nombreSignalements >= 3

    if (doitRestreindre) {
      const { error: updateError } = await supabase
        .from('entrees')
        .update({ is_restricted: true })
        .eq('id', entree_id)

      if (updateError) {
        console.error('Erreur restriction entrée:', updateError)
        return new Response(
          JSON.stringify({ error: 'Erreur lors de la restriction de l\'entrée' }),
          { status: 500, headers: { 'Content-Type': 'application/json' } },
        )
      }

      console.log(`Entrée ${entree_id} restreinte après ${nombreSignalements} signalements.`)
    }

    return new Response(
      JSON.stringify({
        entree_id,
        nombre_signalements: nombreSignalements,
        restricted: doitRestreindre,
      }),
      { status: 200, headers: { 'Content-Type': 'application/json' } },
    )
  } catch (err) {
    console.error('Erreur inattendue:', err)
    return new Response(
      JSON.stringify({ error: 'Erreur interne du serveur' }),
      { status: 500, headers: { 'Content-Type': 'application/json' } },
    )
  }
})
