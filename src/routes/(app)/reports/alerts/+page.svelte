<script lang="ts">
    import { fly, fade } from "svelte/transition";
    import { cubicOut } from "svelte/easing";

    // Mock Alert Rules
    let alertRules = $state([
        {
            id: "al-001",
            name: "Sauti Sol Detection",
            trigger: "song_detected",
            condition: 'Artist = "Sauti Sol"',
            recipient: "mcsk-admin@cmo.ke",
            status: "active",
            last_triggered: "2h ago",
        },
        {
            id: "al-002",
            name: "High Frequency Play",
            trigger: "threshold_reached",
            condition: "Play count > 50 in 24h",
            recipient: "compliance@kamp.or.ke",
            status: "active",
            last_triggered: "5m ago",
        },
        {
            id: "al-003",
            name: "Statement Generated",
            trigger: "new_royalty_statement",
            condition: "Amount > 100k KES",
            recipient: "billing@spaza.com",
            status: "inactive",
            last_triggered: "3d ago",
        },
    ]);

    const triggers = [
        "song_detected",
        "threshold_reached",
        "new_royalty_statement",
        "source_offline",
        "content_mismatch",
    ];

    // Selection & Offcanvas
    let isCreateOpen = $state(false);
    let newRule = $state({
        name: "",
        trigger: "song_detected",
        condition: "",
        recipient: "",
    });

    function handleAdd() {
        const id = `al-${(alertRules.length + 1).toString().padStart(3, "0")}`;
        alertRules = [
            {
                id,
                ...newRule,
                status: "active",
                last_triggered: "Never",
            } as any,
            ...alertRules,
        ];
        isCreateOpen = false;
        newRule = {
            name: "",
            trigger: "song_detected",
            condition: "",
            recipient: "",
        };
    }

    function toggleStatus(id: string) {
        alertRules = alertRules.map((r) =>
            r.id === id
                ? {
                      ...r,
                      status: r.status === "active" ? "inactive" : "active",
                  }
                : r,
        );
    }

    function deleteRule(id: string) {
        alertRules = alertRules.filter((r) => r.id !== id);
    }

    function formatTrigger(t: string) {
        return t
            .split("_")
            .map((w) => w.charAt(0).toUpperCase() + w.slice(1))
            .join(" ");
    }
</script>

<svelte:head>
    <title>Alert Rules | Spaza Airplay</title>
</svelte:head>

<div
    class="flex flex-col h-full w-full relative bg-background-dark overflow-hidden"
>
    <!-- Header -->
    <header
        class="h-20 shrink-0 border-b border-border-dark bg-surface-dark/95 backdrop-blur-sm z-30 px-8 flex flex-col justify-center"
    >
        <!-- Breadcrumbs -->
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
                class="text-[10px] font-bold uppercase tracking-widest text-text-muted"
                >Reports & Alerts</span
            >
            <span class="material-symbols-outlined text-xs text-text-muted"
                >chevron_right</span
            >
            <span
                class="text-[10px] font-bold uppercase tracking-widest text-primary"
                >Alert System Rules</span
            >
        </nav>

        <div class="flex items-center justify-between">
            <div class="flex items-center gap-4">
                <div
                    class="size-10 rounded-xl bg-surface-darker border border-border-dark flex items-center justify-center text-primary shadow-sm"
                >
                    <span class="material-symbols-outlined text-2xl"
                        >notifications_active</span
                    >
                </div>
                <div>
                    <h1
                        class="text-xl font-bold text-white tracking-tight leading-none"
                    >
                        System Alert Rules
                    </h1>
                    <p class="text-[10px] text-text-muted font-medium mt-1">
                        Configure automated triggers and notifications
                    </p>
                </div>
            </div>

            <button
                class="h-9 px-4 btn-primary rounded-lg flex items-center gap-2 shadow-lg shadow-primary/10 hover:shadow-primary/20 transition-all font-bold uppercase tracking-widest text-[10px]"
                onclick={() => (isCreateOpen = true)}
            >
                <span class="material-symbols-outlined text-lg">add_circle</span
                >
                New Rule
            </button>
        </div>
    </header>

    <!-- Main Table -->
    <main class="flex-1 overflow-auto relative">
        <table class="w-full text-left border-collapse">
            <thead class="sticky top-0 z-10 bg-surface-dark shadow-sm">
                <tr>
                    <th
                        class="py-3 px-8 text-[10px] font-bold uppercase tracking-widest text-text-muted border-b border-border-dark w-[20%]"
                        >Rule Identity</th
                    >
                    <th
                        class="py-3 px-4 text-[10px] font-bold uppercase tracking-widest text-text-muted border-b border-border-dark w-[15%]"
                        >Trigger Event</th
                    >
                    <th
                        class="py-3 px-4 text-[10px] font-bold uppercase tracking-widest text-text-muted border-b border-border-dark w-[25%]"
                        >Logic Condition</th
                    >
                    <th
                        class="py-3 px-4 text-[10px] font-bold uppercase tracking-widest text-text-muted border-b border-border-dark w-[20%]"
                        >Notification Target</th
                    >
                    <th
                        class="py-3 px-4 text-[10px] font-bold uppercase tracking-widest text-text-muted border-b border-border-dark w-[10%]"
                        >Last Fire</th
                    >
                    <th
                        class="py-3 px-8 text-[10px] font-bold uppercase tracking-widest text-text-muted border-b border-border-dark text-right w-[10%]"
                        >Manage</th
                    >
                </tr>
            </thead>
            <tbody class="divide-y divide-border-dark/30">
                {#each alertRules as rule}
                    <tr
                        class="group hover:bg-surface-darker/50 transition-colors"
                    >
                        <td class="py-5 px-8">
                            <div class="flex items-center gap-3">
                                <button
                                    class="size-5 rounded-full border border-border-dark flex items-center justify-center transition-colors {rule.status ===
                                    'active'
                                        ? 'bg-emerald-500/10 border-emerald-500/30'
                                        : 'bg-background-dark border-border-dark'}"
                                    onclick={() => toggleStatus(rule.id)}
                                >
                                    <span
                                        class="size-2 rounded-full {rule.status ===
                                        'active'
                                            ? 'bg-emerald-500 shadow-[0_0_8px_rgba(16,185,129,0.5)]'
                                            : 'bg-text-muted/30'}"
                                    ></span>
                                </button>
                                <div>
                                    <h4
                                        class="text-sm font-bold text-white tracking-tight"
                                    >
                                        {rule.name}
                                    </h4>
                                    <span
                                        class="text-[9px] font-mono text-text-muted opacity-50 uppercase"
                                        >#{rule.id}</span
                                    >
                                </div>
                            </div>
                        </td>
                        <td class="py-5 px-4">
                            <span
                                class="px-2 py-0.5 rounded border border-border-dark bg-background-dark text-[9px] font-black text-text-secondary uppercase tracking-wider"
                            >
                                {formatTrigger(rule.trigger)}
                            </span>
                        </td>
                        <td
                            class="py-5 px-4 text-xs text-text-secondary font-medium"
                            >"{rule.condition}"</td
                        >
                        <td class="py-5 px-4 text-xs font-mono text-primary"
                            >{rule.recipient}</td
                        >
                        <td
                            class="py-5 px-4 text-[10px] font-bold text-text-muted uppercase italic"
                            >{rule.last_triggered}</td
                        >
                        <td class="py-5 px-8 text-right">
                            <button
                                class="size-8 rounded-lg text-text-muted hover:text-red-500 transition-colors"
                                onclick={() => deleteRule(rule.id)}
                            >
                                <span class="material-symbols-outlined text-lg"
                                    >delete</span
                                >
                            </button>
                        </td>
                    </tr>
                {/each}
            </tbody>
        </table>
    </main>

    <!-- Create Alert Offcanvas -->
    {#if isCreateOpen}
        <div
            class="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm"
            onclick={() => (isCreateOpen = false)}
            transition:fade={{ duration: 200 }}
        ></div>
        <aside
            class="fixed top-2 bottom-2 right-2 w-[450px] bg-surface-dark border border-border-dark/50 shadow-2xl rounded-2xl z-50 flex flex-col overflow-hidden"
            transition:fly={{
                x: 50,
                duration: 300,
                opacity: 0,
                easing: cubicOut,
            }}
        >
            <div class="p-6 border-b border-border-dark bg-surface-darker/50">
                <h2 class="text-xl font-bold text-white tracking-tight">
                    New System Trigger
                </h2>
                <p
                    class="text-[10px] text-text-muted font-bold uppercase tracking-widest mt-1"
                >
                    Define automated detection logic
                </p>
            </div>

            <div class="flex-1 overflow-y-auto p-8 space-y-6">
                <div class="space-y-4">
                    <div class="space-y-1.5">
                        <label
                            class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                            >Rule Description</label
                        >
                        <input
                            type="text"
                            class="input w-full"
                            placeholder="e.g. Broadcast Variance Alert"
                            bind:value={newRule.name}
                        />
                    </div>

                    <div class="space-y-1.5">
                        <label
                            class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                            >Triggering Event</label
                        >
                        <select
                            class="select w-full"
                            bind:value={newRule.trigger}
                        >
                            {#each triggers as t}
                                <option value={t}>{formatTrigger(t)}</option>
                            {/each}
                        </select>
                    </div>

                    <div class="space-y-1.5">
                        <label
                            class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                            >Execution Condition (SQL Logic)</label
                        >
                        <textarea
                            class="textarea w-full font-mono text-xs"
                            rows="3"
                            placeholder="e.g. metadata-&gt;&gt;&quot;artist&quot; = &quot;Sauti Sol&quot;"
                            bind:value={newRule.condition}
                        ></textarea>
                    </div>

                    <div class="space-y-1.5">
                        <label
                            class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                            >Notification Endpoint (Email/Webhook)</label
                        >
                        <input
                            type="text"
                            class="input w-full font-mono"
                            placeholder="https://hooks.slack.com/..."
                            bind:value={newRule.recipient}
                        />
                    </div>
                </div>
            </div>

            <div class="p-6 border-t border-border-dark bg-surface-darker/50">
                <button
                    class="w-full btn-primary py-4 rounded-xl font-bold uppercase tracking-widest shadow-lg shadow-primary/20 transition-all flex items-center justify-center gap-2"
                    onclick={handleAdd}
                    disabled={!newRule.name}
                >
                    <span class="material-symbols-outlined">save</span>
                    Deploy System Rule
                </button>
            </div>
        </aside>
    {/if}
</div>

<style>
    .select {
        height: 2.75rem;
        background: rgba(15, 23, 42, 0.6);
        border: 1px solid rgba(51, 65, 85, 0.5);
        border-radius: 0.75rem;
        padding-left: 1rem;
        padding-right: 2.5rem;
        color: white;
        font-size: 0.875rem;
        font-weight: 500;
        appearance: none;
        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='rgba(148, 163, 184, 1)'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'%3E%3C/path%3E%3C/svg%3E");
        background-repeat: no-repeat;
        background-position: right 0.75rem center;
        background-size: 1.25rem;
        cursor: pointer;
    }

    .input {
        height: 2.75rem;
        background: rgba(15, 23, 42, 0.6);
        border: 1px solid rgba(51, 65, 85, 0.5);
        border-radius: 0.75rem;
        padding-left: 1rem;
        padding-right: 1rem;
        color: white;
        font-size: 0.875rem;
        font-weight: 500;
        transition: all 0.2s;
    }
    .input:focus {
        outline: none;
        border-color: rgba(16, 185, 129, 0.5);
        box-shadow: 0 0 0 1px rgba(16, 185, 129, 0.2);
    }

    .textarea {
        background: rgba(15, 23, 42, 0.6);
        border: 1px solid rgba(51, 65, 85, 0.5);
        border-radius: 0.75rem;
        padding: 0.75rem 1rem;
        color: white;
        font-size: 0.875rem;
        font-weight: 500;
        transition: all 0.2s;
        resize: none;
    }
</style>
