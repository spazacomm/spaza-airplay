<script lang="ts">
    // Mock Audit Logs
    const auditLogs = [
        {
            id: "log-8821",
            user: "John Doe",
            action: "Statement Approved",
            entity: "Distribution Q4-2025",
            timestamp: "2026-02-04 18:45:10",
            ip: "192.168.1.45",
        },
        {
            id: "log-8820",
            user: "System Agent",
            action: "Detections Processed",
            entity: "Daily Batch (Kenya)",
            timestamp: "2026-02-04 18:30:00",
            ip: "127.0.0.1",
        },
        {
            id: "log-8819",
            user: "Jane Smith",
            action: "User Invited",
            entity: "Kelvin Mutua",
            timestamp: "2026-02-04 17:15:22",
            ip: "192.168.1.12",
        },
        {
            id: "log-8818",
            user: "John Doe",
            action: "Rate Table Deleted",
            entity: "Commercial Radio (Night)",
            timestamp: "2026-02-04 16:20:05",
            ip: "192.168.1.45",
        },
        {
            id: "log-8817",
            user: "Jane Smith",
            action: "Organization Profile Updated",
            entity: "Legal Name Change",
            timestamp: "2026-02-04 15:00:11",
            ip: "192.168.1.12",
        },
        {
            id: "log-8816",
            user: "System Agent",
            action: "Alert Triggered",
            entity: "Sauti Sol Detection",
            timestamp: "2026-02-04 14:45:00",
            ip: "127.0.0.1",
        },
    ];

    function getIcon(action: string) {
        if (action.includes("Approved")) return "verified";
        if (action.includes("Invited") || action.includes("User"))
            return "person_add";
        if (action.includes("Deleted")) return "delete_forever";
        if (action.includes("Updated")) return "edit_note";
        if (action.includes("Triggered")) return "notifications_active";
        return "history";
    }
</script>

<svelte:head>
    <title>Audit Logs | Spaza Airplay</title>
</svelte:head>

<div class="flex flex-col h-full w-full bg-background-dark overflow-hidden">
    <header
        class="h-20 shrink-0 border-b border-border-dark bg-surface-dark/95 z-30 px-8 flex flex-col justify-center"
    >
        <nav class="flex items-center gap-2 mb-1">
            <a
                href="/dashboard"
                class="text-[10px] font-bold uppercase tracking-widest text-text-muted hover:text-primary transition-colors"
                >Dashboard</a
            >
            <span class="material-symbols-outlined text-xs text-text-muted"
                >chevron_right</span
            >
            <span
                class="text-[10px] font-bold uppercase tracking-widest text-primary"
                >System Audit Logs</span
            >
        </nav>
        <div class="flex items-center justify-between">
            <h1 class="text-xl font-bold text-text-main tracking-tight">
                Immutable Activity Audit
            </h1>
            <div class="flex items-center gap-3">
                <span
                    class="px-2 py-1 rounded bg-amber-500/10 border border-amber-500/20 text-[9px] font-bold text-amber-500 uppercase tracking-widest"
                    >Read Only</span
                >
                <button
                    class="h-8 px-3 rounded-lg border border-border-dark bg-surface-darker text-[10px] font-bold text-text-main uppercase tracking-widest flex items-center gap-2 hover:bg-surface-dark transition-all"
                >
                    <span class="material-symbols-outlined text-base"
                        >download</span
                    >
                    Export CSV
                </button>
            </div>
        </div>
    </header>

    <main class="flex-1 overflow-auto bg-white border-t border-slate-200">
        <table class="table-enterprise">
            <thead>
                <tr>
                    <th class="px-8 whitespace-nowrap">Timestamp</th>
                    <th class="px-6 whitespace-nowrap">Actor</th>
                    <th class="px-6 whitespace-nowrap">Action Event</th>
                    <th class="px-6 whitespace-nowrap">Target Entity</th>
                    <th class="px-8 text-right whitespace-nowrap">Origin IP</th>
                </tr>
            </thead>
            <tbody>
                {#each auditLogs as log}
                    <tr class="group">
                        <td
                            class="px-8 py-3 text-xs font-mono text-slate-600 font-semibold italic"
                        >
                            {log.timestamp}
                        </td>
                        <td class="px-6 py-3 text-sm font-bold text-slate-900">
                            {log.user}
                        </td>
                        <td class="px-6 py-3">
                            <span class="text-xs font-semibold text-slate-700">
                                {log.action}
                            </span>
                        </td>
                        <td class="px-6 py-3">
                            <span
                                class="px-2 py-0.5 rounded border border-slate-200 bg-slate-50 text-[10px] font-bold text-primary tracking-tight"
                            >
                                {log.entity}
                            </span>
                        </td>
                        <td
                            class="px-8 py-3 text-right font-mono text-[10px] text-slate-500 font-medium"
                        >
                            {log.ip}
                        </td>
                    </tr>
                {/each}
            </tbody>
        </table>
    </main>
</div>
