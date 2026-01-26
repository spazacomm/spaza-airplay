import { fail, redirect } from '@sveltejs/kit';
import type { Actions } from './$types';

export const actions: Actions = {
    register: async ({ request, locals }) => {
        const formData = await request.formData();
        const email = formData.get('email') as string;
        const password = formData.get('password') as string;
        const fullName = formData.get('fullName') as string;

        if (!email || !password || !fullName) {
            return fail(400, { email, fullName, message: 'All fields are required' });
        }

        const { data, error } = await locals.supabase.auth.signUp({
            email,
            password,
            options: {
                data: {
                    full_name: fullName,
                }
            }
        });

        if (error) {
            return fail(error.status || 500, { email, fullName, message: error.message });
        }

        throw redirect(303, '/onboarding/step-1');
    }
};
