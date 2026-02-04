<script lang="ts">
    let prefs = $state({
        default_currency: "KES",
        timezone: "Africa/Nairobi (UTC+3)",
        email_notifications: true,
        auto_approve_statements: false,
        high_density_tables: true,
        theme: "dark",
    });

    const currencies = ["KES", "USD", "EUR", "GBP", "UGX", "TZS"];
    const timezones = [
        "Africa/Nairobi (UTC+3)",
        "Africa/Kampala (UTC+3)",
        "Africa/Lagos (UTC+1)",
        "UTC",
    ];

    function handleSave() {
        // Mock save
    }
</script>

<svelte:head>
    <title>Preferences | Spaza Airplay</title>
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
                >System Preferences</span
            >
        </nav>
        <h1 class="text-xl font-bold text-white tracking-tight leading-none">
            Global Preferences
        </h1>
    </header>

    <main class="flex-1 overflow-y-auto p-8 max-w-4xl">
        <div class="space-y-8">
            <!-- Appearance Section -->
            <section
                class="p-8 bg-surface-darker/20 border border-border-dark rounded-3xl space-y-6"
            >
                <div class="flex items-center gap-4 mb-2">
                    <span class="material-symbols-outlined text-primary"
                        >palette</span
                    >
                    <h2
                        class="text-xs font-black text-white uppercase tracking-[0.2em]"
                    >
                        Appearance & Display
                    </h2>
                </div>

                <div class="grid grid-cols-2 gap-10">
                    <div
                        class="flex items-center justify-between p-4 bg-background-dark/50 border border-border-dark rounded-xl"
                    >
                        <div>
                            <p
                                class="text-[11px] font-bold text-white uppercase tracking-widest"
                            >
                                High Density Mode
                            </p>
                            <p class="text-[9px] text-text-muted mt-0.5">
                                Show more data in tables by reducing padding
                            </p>
                        </div>
                        <button
                            class="size-10 rounded-lg border border-border-dark bg-surface-darker flex items-center justify-center {prefs.high_density_tables
                                ? 'text-primary'
                                : 'text-text-muted'}"
                            onclick={() =>
                                (prefs.high_density_tables =
                                    !prefs.high_density_tables)}
                        >
                            <span class="material-symbols-outlined"
                                >{prefs.high_density_tables
                                    ? "check_box"
                                    : "check_box_outline_blank"}</span
                            >
                        </button>
                    </div>

                    <div
                        class="flex items-center justify-between p-4 bg-background-dark/50 border border-border-dark rounded-xl opacity-50 cursor-not-allowed"
                    >
                        <div>
                            <p
                                class="text-[11px] font-bold text-white uppercase tracking-widest"
                            >
                                Glassmorphism FX
                            </p>
                            <p class="text-[9px] text-text-muted mt-0.5">
                                Enable background blur on all surface panels
                            </p>
                        </div>
                        <span class="material-symbols-outlined text-text-muted"
                            >radio_button_checked</span
                        >
                    </div>
                </div>
            </section>

            <!-- Localization Section -->
            <section
                class="p-8 bg-surface-darker/20 border border-border-dark rounded-3xl space-y-6"
            >
                <div class="flex items-center gap-4 mb-2">
                    <span class="material-symbols-outlined text-primary"
                        >language</span
                    >
                    <h2
                        class="text-xs font-black text-white uppercase tracking-[0.2em]"
                    >
                        Regional & Financial
                    </h2>
                </div>

                <div class="grid grid-cols-2 gap-6">
                    <div class="space-y-1.5">
                        <label
                            class="text-[9px] font-black uppercase text-text-secondary tracking-widest ml-1"
                            >Reporting Currency</label
                        >
                        <select
                            class="select w-full"
                            bind:value={prefs.default_currency}
                        >
                            {#each currencies as c}
                                <option value={c}>{c}</option>
                            {/each}
                        </select>
                    </div>
                    <div class="space-y-1.5">
                        <label
                            class="text-[9px] font-black uppercase text-text-secondary tracking-widest ml-1"
                            >System Timezone</label
                        >
                        <select
                            class="select w-full"
                            bind:value={prefs.timezone}
                        >
                            {#each timezones as t}
                                <option value={t}>{t}</option>
                            {/each}
                        </select>
                    </div>
                </div>
            </section>

            <!-- Automation Section -->
            <section
                class="p-8 bg-surface-darker/20 border border-border-dark rounded-3xl space-y-6"
            >
                <div class="flex items-center gap-4 mb-2">
                    <span class="material-symbols-outlined text-primary"
                        >robot_2</span
                    >
                    <h2
                        class="text-xs font-black text-white uppercase tracking-[0.2em]"
                    >
                        Automation & Workflow
                    </h2>
                </div>

                <div class="space-y-4">
                    <div
                        class="flex items-center justify-between p-5 bg-background-dark/50 border border-border-dark rounded-2xl group hover:border-primary/30 transition-all cursor-pointer"
                        onclick={() =>
                            (prefs.auto_approve_statements =
                                !prefs.auto_approve_statements)}
                    >
                        <div class="flex items-center gap-4">
                            <div
                                class="size-10 rounded-xl bg-surface-dark border border-border-dark flex items-center justify-center text-text-muted group-hover:text-primary transition-colors"
                            >
                                <span class="material-symbols-outlined text-xl"
                                    >verified</span
                                >
                            </div>
                            <div>
                                <p
                                    class="text-xs font-bold text-white uppercase tracking-widest"
                                >
                                    Auto-Approve Low Value Statements
                                </p>
                                <p class="text-[10px] text-text-muted mt-1">
                                    Automatically approve distributions under
                                    500 KES
                                </p>
                            </div>
                        </div>
                        <div
                            class="w-12 h-6 rounded-full border border-border-dark bg-background-dark relative transition-all {prefs.auto_approve_statements
                                ? 'bg-primary/20 border-primary/40'
                                : ''}"
                        >
                            <div
                                class="absolute top-1 left-1 size-4 rounded-full bg-text-muted transition-all {prefs.auto_approve_statements
                                    ? 'translate-x-6 bg-primary shadow-[0_0_8px_rgba(16,185,129,0.5)]'
                                    : ''}"
                            ></div>
                        </div>
                    </div>
                </div>
            </section>

            <div class="pt-4 flex justify-end">
                <button
                    class="h-12 px-10 btn-primary rounded-xl font-black uppercase tracking-widest text-xs shadow-xl shadow-primary/20"
                    onclick={handleSave}
                >
                    Deploy System Configuration
                </button>
            </div>
        </div>
    </main>
</div>

<style>
    .select {
        height: 2.75rem;
        background: #f8fafc;
        border: 1px solid #e2e8f0;
        border-radius: 0.75rem;
        padding: 0 1rem;
        color: #0f172a;
        font-size: 13px;
        font-weight: 500;
        appearance: none;
        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='rgba(71, 85, 105, 1)'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'%3E%3C/path%3E%3C/svg%3E");
        background-repeat: no-repeat;
        background-position: right 0.75rem center;
        background-size: 1.15rem;
        cursor: pointer;
    }
</style>
