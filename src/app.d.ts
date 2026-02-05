import type { SupabaseClient, User } from '@supabase/supabase-js'

declare global {
	namespace App {
		// interface Error {}
		interface Locals {
			supabase: SupabaseClient
			getUser: () => Promise<User | null>
		}
		interface PageData {
			[key: string]: any
			session?: string | null
			user?: (User & { profile?: any }) | null
		}
		// interface PageState {}
		// interface Platform {}
	}
}

export { }
