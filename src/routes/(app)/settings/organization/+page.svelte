<script lang="ts">
    let org = $state({
        name: "Spaza Media Group",
        legal_name: "Spaza Broadcasters Ltd",
        tax_id: "PIN-KE-998811",
        email: "billing@spaza.com",
        phone: "+254 700 111 222",
        address: "Spaza Towers, 4th Floor, Nairobi, Kenya",
        tier: "Enterprise",
    });

    function handleSave() {
        // Mock save
    }
</script>

<svelte:head>
    <title>Organization | Spaza Airplay</title>
</svelte:head>

<div class="flex flex-col h-full w-full bg-background-dark overflow-hidden">
    <header
        class="h-20 shrink-0 border-b border-border-dark bg-surface-dark/95 z-30 px-8 flex flex-col justify-center"
    >
        <nav class="flex items-center gap-2 mb-1">
            <a
                href="/dashboard"
                class="text-[10px] font-bold uppercase tracking-widest text-text-muted hover:text-primary"
                >Dashboard</a
            >
            <span class="material-symbols-outlined text-xs text-text-muted"
                >chevron_right</span
            >
            <span
                class="text-[10px] font-bold uppercase tracking-widest text-primary"
                >Organization Settings</span
            >
        </nav>
        <h1 class="text-xl font-bold text-white tracking-tight">
            Organization Profile
        </h1>
    </header>

    <main class="flex-1 overflow-y-auto p-8 max-w-4xl">
        <div
            class="bg-surface-darker/30 border border-border-dark p-10 rounded-3xl space-y-10 shadow-2xl"
        >
            <div
                class="flex items-center gap-8 mb-4 pb-8 border-b border-border-dark/30"
            >
                <div
                    class="size-24 rounded-3xl bg-surface-dark border border-border-dark flex items-center justify-center text-4xl font-black text-primary uppercase shadow-inner"
                >
                    {org.name.substring(0, 2)}
                </div>
                <div>
                    <h2
                        class="text-2xl font-black text-white uppercase tracking-tighter"
                    >
                        {org.name}
                    </h2>
                    <span
                        class="px-2 py-0.5 rounded bg-primary/10 text-primary text-[9px] font-bold uppercase tracking-[0.2em]"
                        >{org.tier} License</span
                    >
                </div>
            </div>

            <div class="grid grid-cols-2 gap-8">
                <div class="space-y-1.5">
                    <label
                        class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                        >Legal Entity Name</label
                    >
                    <input
                        type="text"
                        class="input w-full"
                        bind:value={org.legal_name}
                    />
                </div>
                <div class="space-y-1.5">
                    <label
                        class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                        >Tax / Registration ID</label
                    >
                    <input
                        type="text"
                        class="input w-full font-mono"
                        bind:value={org.tax_id}
                    />
                </div>
                <div class="space-y-1.5">
                    <label
                        class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                        >Official Email</label
                    >
                    <input
                        type="email"
                        class="input w-full"
                        bind:value={org.email}
                    />
                </div>
                <div class="space-y-1.5">
                    <label
                        class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                        >Contact Phone</label
                    >
                    <input
                        type="tel"
                        class="input w-full"
                        bind:value={org.phone}
                    />
                </div>
                <div class="space-y-1.5 col-span-2">
                    <label
                        class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                        >Physical HQ Address</label
                    >
                    <textarea
                        class="textarea w-full"
                        rows="3"
                        bind:value={org.address}
                    ></textarea>
                </div>
            </div>

            <div class="pt-6">
                <button
                    class="btn-primary w-full py-4 rounded-2xl font-black uppercase tracking-[0.2em]"
                    onclick={handleSave}>Save Organization Profile</button
                >
            </div>
        </div>
    </main>
</div>

<style>
    .input {
        height: 3rem;
        background: rgba(15, 23, 42, 0.4);
        border: 1px solid rgba(51, 65, 85, 0.5);
        border-radius: 1rem;
        padding: 0 1.25rem;
        color: white;
    }
    .textarea {
        background: rgba(15, 23, 42, 0.4);
        border: 1px solid rgba(51, 65, 85, 0.5);
        border-radius: 1rem;
        padding: 1rem;
        color: white;
        resize: none;
    }
</style>
