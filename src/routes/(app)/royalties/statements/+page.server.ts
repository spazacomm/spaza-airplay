import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ locals }) => {
    const supabase = locals.supabase;

    const { data: statements } = await supabase
        .from('royalty_statements')
        .select(`
            *,
            profiles (
                full_name
            ),
            royalty_societies (
                name
            )
        `)
        .order('generated_at', { ascending: false });

    return {
        statements: statements?.map(stmt => ({
            id: stmt.id,
            period_start: stmt.period_start,
            period_end: stmt.period_end,
            society_name: stmt.royalty_societies?.name || 'Unknown',
            rights_holder: stmt.profiles?.full_name || 'Generic Holder',
            total_amount: Number(stmt.total_amount) || 0,
            status: stmt.status,
            generated_at: stmt.generated_at,
            currency: stmt.currency || 'KES',
            // Details would typically come from a child table or JSONB
            details: stmt.metadata?.details || []
        })) || []
    };
};
