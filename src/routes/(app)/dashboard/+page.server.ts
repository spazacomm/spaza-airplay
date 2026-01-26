import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ locals }) => {
    const supabase = locals.supabase;

    // Fetch Stats
    const { data: summary } = await supabase
        .from('earnings_summaries')
        .select('*')
        .single();

    // Fetch Recent Airplay
    const { data: recentLogs } = await supabase
        .from('airplay_logs')
        .select(`
            *,
            tracks (
                title,
                cover_url
            ),
            broadcasters (
                name,
                location
            )
        `)
        .order('played_at', { ascending: false })
        .limit(5);

    // Fetch Top Performing Tracks
    const { data: topTracks } = await supabase
        .from('tracks')
        .select(`
            id,
            title,
            album,
            cover_url,
            airplay_logs (
                royalty_estimated
            )
        `)
        .limit(3);

    return {
        summary: summary || {
            total_plays: 1200000,
            total_earnings: 12450.0,
            updated_at: new Date().toISOString()
        },
        recentPlays: (recentLogs as any[])?.map(log => ({
            id: log.id,
            song: log.tracks.title,
            station: log.broadcasters.name,
            location: log.broadcasters.location,
            time: formatTimeAgo(log.played_at),
            cover: log.tracks.cover_url,
            isNew: new Date(log.played_at).getTime() > Date.now() - 3600000
        })) || [],
        topTracks: (topTracks as any[])?.map((track, index) => ({
            rank: index + 1,
            title: track.title,
            album: track.album,
            plays: "Unknown",
            earnings: (track.airplay_logs as any[]).reduce((acc: number, log: any) => acc + (log.royalty_estimated || 0), 0),
            trend: 5,
            cover: track.cover_url
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
