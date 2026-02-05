import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ locals }) => {
    const supabase = locals.supabase;

    const { data: sources } = await supabase
        .from('sources')
        .select(`
            *,
            rate_tables (
                id,
                usage_type,
                rate_per_play,
                flat_fee,
                status
            )
        `)
        .order('name');

    return {
        sources: sources?.map(src => ({
            id: src.id,
            name: src.name,
            type: src.type,
            ingestion_type: src.metadata?.ingestion_type || 'broadcast',
            country: src.country,
            region: src.city,
            location: `${src.city}, ${src.country}`,
            device_id: src.metadata?.device_id || 'N/A',
            status: src.status,
            last_heartbeat: src.metadata?.last_heartbeat || 'Unknown',
            signal_strength: src.metadata?.signal_strength || 0,
            royalty_rates: src.rate_tables?.map((rt: any) => ({
                id: rt.id,
                method: rt.rate_per_play ? 'per_play' : 'flat_fee',
                rate: rt.rate_per_play || rt.flat_fee,
                currency: 'KES', // Default
                status: rt.status,
                usage_type: rt.usage_type
            })) || []
        })) || []
    };
};
