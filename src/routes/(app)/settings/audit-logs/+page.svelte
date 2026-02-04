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
            <h1 class="text-xl font-bold text-white tracking-tight">
                Immutable Activity Audit
            </h1>
            <div class="flex items-center gap-3">
                <span
                    class="px-2 py-1 rounded bg-amber-500/10 border border-amber-500/20 text-[9px] font-bold text-amber-500 uppercase tracking-widest"
                    >Read Only</span
                >
                <button
                    class="h-8 px-3 rounded-lg border border-border-dark bg-surface-darker text-[10px] font-bold text-white uppercase tracking-widest flex items-center gap-2 hover:bg-surface-dark transition-all"
                >
                    <span class="material-symbols-outlined text-base"
                        >download</span
                    >
                    Export CSV
                </button>
            </div>
        </div>
    </header>

    <main class="flex-1 overflow-auto">
        <table class="w-full text-left border-collapse">
            <thead class="sticky top-0 z-10 bg-surface-dark shadow-xl">
                <tr>
                    <th
                        class="py-4 px-8 text-[10px] font-bold uppercase tracking-[0.2em] text-text-muted border-b border-border-dark"
                        >Timestamp</th
                    >
                    <th
                        class="py-4 px-4 text-[10px] font-bold uppercase tracking-[0.2em] text-text-muted border-b border-border-dark"
                        >Actor</th
                    >
                    <th
                        class="py-4 px-4 text-[10px] font-bold uppercase tracking-[0.2em] text-text-muted border-b border-border-dark"
                        >Action Event</th
                    >
                    <th
                        class="py-4 px-4 text-[10px] font-bold uppercase tracking-[0.2em] text-text-muted border-b border-border-dark"
                        >Target Entity</th
                    >
                    <th
                        class="py-4 px-8 text-[10px] font-bold uppercase tracking-[0.2em] text-text-muted border-b border-border-dark text-right"
                        >Origin IP</th
                    >
                </tr>
            </thead>
            <tbody class="divide-y divide-border-dark/20 bg-surface-darker/10">
                {#each auditLogs as log}
                    <tr
                        class="group hover:bg-surface-darker/40 transition-colors"
                    >
                        <td class="py-5 px-8">
                            <div
                                class="text-[11px] font-mono font-bold text-text-secondary"
                            >
                                {log.timestamp}
                            </div>
                        </td>
                        <td
                            class="py-5 px-4 font-bold text-white text-xs tracking-tight"
                            >{log.user}</td
                        >
                        <td class="py-5 px-4">
                            <div class="flex items-center gap-2.5">
                                <div
                                    class="size-7 rounded-lg bg-surface-dark border border-border-dark flex items-center justify-center text-text-muted group-hover:text-primary transition-colors"
                                >
                                    <span
                                        class="material-symbols-outlined text-base"
                                        >{getIcon(log.action)}</span
                                    >
                                </div>
                                <span
                                    class="text-xs font-semibold text-text-secondary"
                                    >{log.action}</span
                                >
                            </div>
                        </td>
                        <td class="py-5 px-4">
                            <span
                                class="px-2 py-0.5 rounded border border-border-dark bg-background-dark text-[10px] font-bold text-primary italic"
                                >"{log.entity}"</span
                            >
                        </td>
                        <td
                            class="py-5 px-8 text-right font-mono text-[10px] text-text-muted opacity-60 italic"
                            >{log.ip}</td
                        >
                    </tr>
                {/each}
            </tbody>
        </table>
    </main>
</div>
