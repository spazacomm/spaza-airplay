import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ locals }) => {
    const supabase = locals.supabase;

    // Fetch Songs with Artist info
    const { data: songs } = await supabase
        .from('tracks')
        .select(`
            *,
            artists (
                name
            )
        `)
        .order('created_at', { ascending: false });

    return {
        songs: (songs as any[])?.map(song => ({
            id: song.id,
            title: song.title,
            artist: (song.artists as any)?.name || 'Unknown Artist',
            genre: song.genre || 'Various',
            isrc: song.isrc || 'Pending',
            date: new Date(song.release_date || song.created_at).toLocaleDateString('en-US', {
                month: 'short',
                day: '2-digit',
                year: 'numeric'
            }),
            status: song.status,
            plays: "0",
            earnings: "$0.00",
            cover: song.cover_url || "https://images.unsplash.com/photo-1614613535308-eb5fbd3d2c17?q=80&w=200",
            active: song.status === 'Live'
        })) || []
    };
};
