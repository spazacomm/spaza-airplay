import { fail, redirect } from '@sveltejs/kit';
import type { Actions } from './$types';

export const actions: Actions = {
    login: async ({ request, locals }) => {
        const formData = await request.formData();
        const email = formData.get('email') as string;
        const password = formData.get('password') as string;

        if (!email || !password) {
            return fail(400, { email, message: 'Email and password are required' });
        }

        const { error } = await locals.supabase.auth.signInWithPassword({
            email,
            password
        });

        if (error) {
            return fail(error.status || 500, { email, message: error.message });
        }

        throw redirect(303, '/dashboard');
    }
};
