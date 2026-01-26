import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ locals }) => {
    const user = await locals.getUser();

    if (user) {
        const { data: profile } = await locals.supabase
            .from('profiles')
            .select('*')
            .eq('id', user.id)
            .single();

        const { data: notifications } = await locals.supabase
            .from('notification_settings')
            .select('*')
            .eq('user_id', user.id)
            .single();

        return {
            profile,
            notifications
        };
    }

    return {
        profile: null,
        notifications: null
    };
};
