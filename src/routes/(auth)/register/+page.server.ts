import { fail, redirect } from '@sveltejs/kit';
import type { Actions } from './$types';

export const actions: Actions = {
    default: async ({ request, locals }) => {
        const formData = await request.formData();
        const email = formData.get('email') as string;
        const password = formData.get('password') as string;
        const fullName = formData.get('name') as string;

        if (!email || !password || !fullName) {
            return fail(400, { email, name: fullName, message: 'All fields are required' });
        }

        const { data, error } = await locals.supabase.auth.signUp({
            email,
            password,
            options: {
                data: {
                    full_name: fullName,
                },
            },
        });

        if (error) {
            return fail(400, { email, name: fullName, message: error.message });
        }

        if (data.user) {
            // Note: Supabase hooks might handle profile creation, 
            // but we'll ensure it here if needed, or assume the trigger exists.
            // Based on schema.sql, profiles table exists.

            // Re-checking schema.sql:
            // CREATE TABLE profiles (
            //     id UUID PRIMARY KEY,
            //     email TEXT UNIQUE NOT NULL,
            //     full_name TEXT,
            //     role user_role NOT NULL DEFAULT 'artist',
            //     ...
            // );

            // We should manually insert profile if there's no trigger.
            // But usually in SvelteKit + Supabase projects, we check if it exists.
            const { error: profileError } = await locals.supabase
                .from('profiles')
                .insert({
                    id: data.user.id,
                    email: email,
                    full_name: fullName,
                    role: 'artist'
                });

            if (profileError) {
                console.error('Profile creation error:', profileError);
                // We don't necessarily want to fail the whole thing if the user was created,
                // but it's good to know.
            }
        }

        throw redirect(303, '/dashboard');
    },
};
