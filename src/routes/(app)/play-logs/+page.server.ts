import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ locals }) => {
    const supabase = locals.supabase;

    // Fetch Play Logs
    const { data: logs } = await supabase
        .from('play_logs')
        .select(`
            *,
            recordings (
                title,
                isrc,
                metadata
            ),
            sources (
                name,
                country
            )
        `)
        .order('timestamp_start', { ascending: false })
        .limit(100);

    return {
        logs: (logs as any[])?.map(log => ({
            id: log.id,
            timestamp: new Date(log.timestamp_start).toLocaleDateString('en-US', {
                month: 'short',
                day: '2-digit',
                hour: '2-digit',
                minute: '2-digit'
            }),
            song: log.recordings.title,
            artist: log.recordings.metadata?.artist || 'Unknown Artist',
            broadcaster: log.sources.name,
            country: log.sources.country === 'Nigeria' ? '🇳🇬' :
                log.sources.country === 'South Africa' ? '🇿🇦' :
                    log.sources.country === 'Kenya' ? '🇰🇪' :
                        log.sources.country === 'Uganda' ? '🇺🇬' :
                            log.sources.country === 'Tanzania' ? '🇹🇿' : '🌍',
            tier: 'Tier 1',
            duration: log.duration_played_seconds ? `${Math.floor(log.duration_played_seconds / 60)}:${Math.floor(log.duration_played_seconds % 60).toString().padStart(2, '0')}` : '0:00',
            royalty: 5.0,
            status: 'verified',
            confidence: log.confidence_score || 0.9,
            fingerprint_id: log.id.slice(0, 8).toUpperCase(),
            multiplier: 1.1
        })) || []
    };
};
