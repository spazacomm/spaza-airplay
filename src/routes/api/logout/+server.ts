import { redirect } from '@sveltejs/kit';
import type { RequestHandler } from './$types';

export const POST: RequestHandler = async ({ locals }) => {
    const { error } = await locals.supabase.auth.signOut();

    if (error) {
        console.error('Error logging out:', error.message);
    }

    throw redirect(303, '/');
};
