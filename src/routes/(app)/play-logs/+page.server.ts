import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ locals }) => {
    const supabase = locals.supabase;

    // Fetch Airplay Logs
    const { data: logs } = await supabase
        .from('airplay_logs')
        .select(`
            *,
            tracks (
                title,
                isrc
            ),
            broadcasters (
                name,
                country,
                tier
            )
        `)
        .order('played_at', { ascending: false })
        .limit(20);

    return {
        logs: (logs as any[])?.map(log => ({
            id: log.id,
            timestamp: new Date(log.played_at).toLocaleDateString('en-US', {
                month: 'short',
                day: '2-digit',
                hour: '2-digit',
                minute: '2-digit'
            }),
            song: log.tracks.title,
            broadcaster: log.broadcasters.name,
            country: log.broadcasters.country === 'Nigeria' ? '🇳🇬' :
                log.broadcasters.country === 'South Africa' ? '🇿🇦' :
                    log.broadcasters.country === 'Kenya' ? '🇰🇪' : '🌍',
            tier: `Tier ${log.broadcasters.tier}`,
            duration: log.duration,
            royalty: log.royalty_estimated,
            status: log.status,
        })) || []
    };
};
