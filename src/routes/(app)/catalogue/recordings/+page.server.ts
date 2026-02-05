import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ locals }) => {
    const supabase = locals.supabase;

    const { data: recordings } = await supabase
        .from('recordings')
        .select(`
            id,
            title,
            isrc,
            version,
            duration_seconds,
            release_date,
            metadata,
            works (
                title
            )
        `)
        .order('created_at', { ascending: false });

    return {
        recordings: recordings?.map(rec => ({
            id: rec.id,
            title: rec.title,
            isrc: rec.isrc,
            version: rec.version || 'Original',
            duration: rec.duration_seconds ? `${Math.floor(rec.duration_seconds / 60)}:${(rec.duration_seconds % 60).toString().padStart(2, '0')}` : '0:00',
            releaseDate: rec.release_date,
            workTitle: (rec.works as any)?.title || 'Unknown Work',
            label: rec.metadata?.label || 'Independent',
            status: rec.metadata?.status || 'Live',
            cover: rec.metadata?.cover_url || null,
            artist: rec.metadata?.artist || 'Unknown Artist'
        })) || []
    };
};
