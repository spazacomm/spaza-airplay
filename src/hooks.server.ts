import { createServerClient } from '@supabase/ssr'
import type { Handle } from '@sveltejs/kit'
import { env } from '$env/dynamic/public'

export const handle: Handle = async ({ event, resolve }) => {
    const supabaseUrl = env.PUBLIC_SUPABASE_URL || '';
    const supabaseAnonKey = env.PUBLIC_SUPABASE_ANON_KEY || '';

    event.locals.supabase = createServerClient(
        supabaseUrl,
        supabaseAnonKey,
        {
            cookies: {
                getAll: () => event.cookies.getAll(),
                setAll: (cookiesToSet) => {
                    cookiesToSet.forEach(({ name, value, options }) => {
                        event.cookies.set(name, value, { ...options, path: '/' })
                    })
                },
            },
        }
    )

    /**
     * Unlike `supabase.auth.getSession()`, which returns the session from the cookie,
     * `supabase.auth.getUser()` always revalidates the session with the Supabase Auth server.
     */
    event.locals.getUser = async () => {
        if (!supabaseUrl || !supabaseAnonKey) return null;
        try {
            const {
                data: { user },
            } = await event.locals.supabase.auth.getUser()
            return user
        } catch {
            return null;
        }
    }

    return resolve(event, {
        filterSerializedResponseHeaders(name) {
            return name === 'content-range' || name === 'x-chunk-integrity'
        },
    })
}
