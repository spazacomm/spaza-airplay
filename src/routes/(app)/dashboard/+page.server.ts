import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ locals }) => {
    const supabase = locals.supabase;

    // Fetch Stats (Counts from actual tables)
    const { count: totalPlays } = await supabase
        .from('play_logs')
        .select('*', { count: 'exact', head: true });

    const { data: earningsData } = await supabase
        .from('royalty_statements')
        .select('total_amount');

    const totalEarnings = earningsData?.reduce((acc, curr) => acc + (Number(curr.total_amount) || 0), 0) || 0;

    const { count: activeSources } = await supabase
        .from('sources')
        .select('*', { count: 'exact', head: true })
        .eq('status', 'active');

    // Fetch Recent Play Logs Joined with Recordings and Sources
    const { data: recentLogs } = await supabase
        .from('play_logs')
        .select(`
            id,
            timestamp_start,
            confidence_score,
            recordings (
                title,
                metadata
            ),
            sources (
                name,
                city,
                country
            )
        `)
        .order('timestamp_start', { ascending: false })
        .limit(5);

    // Fetch Top Performing Recordings
    // In a real app we'd aggregate via RPC or a View, 
    // but for the seed data we'll just fetch some recordings.
    const { data: topRecordings } = await supabase
        .from('recordings')
        .select(`
            id,
            title,
            metadata,
            duration_seconds
        `)
        .limit(3);

    return {
        summary: {
            total_plays: totalPlays || 0,
            total_earnings: totalEarnings,
            active_sources: activeSources || 0,
            updated_at: new Date().toISOString()
        },
        recentPlays: (recentLogs as any[])?.map(log => ({
            id: log.id,
            song: log.recordings.title,
            station: log.sources.name,
            location: `${log.sources.city}, ${log.sources.country}`,
            time: formatTimeAgo(log.timestamp_start),
            cover: log.recordings.metadata?.cover_url || null,
            isNew: new Date(log.timestamp_start).getTime() > Date.now() - 3600000
        })) || [],
        topTracks: (topRecordings as any[])?.map((track, index) => ({
            rank: index + 1,
            title: track.title,
            album: track.metadata?.album || 'Unknown Album',
            plays: Math.floor(Math.random() * 5000 + 1000), // Mocked for now as we don't have counts easily
            earnings: Math.floor(Math.random() * 200 + 50),
            trend: 5,
            cover: track.metadata?.cover_url || null
        })) || []
    };
};

function formatTimeAgo(dateString: string) {
    const seconds = Math.floor((new Date().getTime() - new Date(dateString).getTime()) / 1000);
    if (seconds < 60) return 'just now';
    const minutes = Math.floor(seconds / 60);
    if (minutes < 60) return `${minutes}m ago`;
    const hours = Math.floor(minutes / 60);
    if (hours < 24) return `${hours}h ago`;
    return new Date(dateString).toLocaleDateString();
}
