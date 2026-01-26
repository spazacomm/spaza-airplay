import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ locals }) => {
    const user = await locals.getUser();

    if (user) {
        const { data: logs } = await locals.supabase
            .from('security_logs')
            .select('*')
            .eq('user_id', user.id)
            .order('created_at', { ascending: false })
            .limit(10);

        return {
            securityLogs: logs || []
        };
    }

    return {
        securityLogs: []
    };
};
