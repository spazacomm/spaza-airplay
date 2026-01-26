import type { LayoutServerLoad } from './$types';

export const load: LayoutServerLoad = async ({ locals }) => {
    const user = await locals.getUser();

    if (user) {
        const { data: profile } = await locals.supabase
            .from('profiles')
            .select('*')
            .eq('id', user.id)
            .single();

        return {
            user: {
                ...user,
                profile
            }
        };
    }

    return {
        user: null
    };
};
