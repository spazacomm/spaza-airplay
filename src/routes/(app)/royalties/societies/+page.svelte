<script lang="ts">
    const societies = [
        {
            id: "cm-01",
            name: "MCSK",
            fullName: "Music Copyright Society of Kenya",
            type: "CMO",
            country: "Kenya",
            currency: "KES",
            status: "Active",
        },
        {
            id: "cm-02",
            name: "KAMP",
            fullName: "Kenya Association of Music Producers",
            type: "CMO",
            country: "Kenya",
            currency: "KES",
            status: "Active",
        },
        {
            id: "cm-03",
            name: "PRISK",
            fullName: "Performers Rights Society of Kenya",
            type: "CMO",
            country: "Kenya",
            currency: "KES",
            status: "Active",
        },
        {
            id: "cm-04",
            name: "SAMRO",
            fullName: "Southern African Music Rights Organisation",
            type: "CMO",
            country: "South Africa",
            currency: "ZAR",
            status: "Partner",
        },
    ];
</script>

<svelte:head>
    <title>Societies | Spaza Airplay</title>
</svelte:head>

<div class="flex h-full flex-col overflow-hidden -m-4 md:-m-8">
    <div
        class="px-8 py-6 border-b border-border-dark shrink-0 bg-surface-darker"
    >
        <div class="flex justify-between items-end">
            <div>
                <h1 class="text-3xl font-bold tracking-tight text-white">
                    Royalty Societies
                </h1>
                <p class="text-text-secondary mt-1">
                    Manage CMO/PRO relationships and configuration.
                </p>
            </div>
            <button class="btn-primary">
                <span class="material-symbols-outlined">add</span>
                Add Society
            </button>
        </div>
    </div>

    <div class="flex-1 overflow-auto bg-surface-dark p-8">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {#each societies as society}
                <div class="card p-6 flex flex-col gap-4 group">
                    <div class="flex justify-between items-start">
                        <div
                            class="size-12 rounded-lg bg-surface-darker border border-border-dark flex items-center justify-center font-bold text-xl text-white"
                        >
                            {society.name.substring(0, 2)}
                        </div>
                        <span
                            class="badge {society.status === 'Active'
                                ? 'badge-success'
                                : 'bg-blue-500/10 text-blue-500 border-blue-500/20'} uppercase text-[10px]"
                            >{society.status}</span
                        >
                    </div>

                    <div>
                        <h3 class="font-bold text-white text-lg">
                            {society.name}
                        </h3>
                        <p class="text-sm text-text-secondary line-clamp-1">
                            {society.fullName}
                        </p>
                    </div>

                    <div class="grid grid-cols-2 gap-2 mt-2">
                        <div
                            class="p-2 border border-border-dark rounded bg-surface-darker"
                        >
                            <span
                                class="text-[10px] text-text-secondary uppercase font-bold block"
                                >Country</span
                            >
                            <span class="text-sm font-medium text-white"
                                >{society.country}</span
                            >
                        </div>
                        <div
                            class="p-2 border border-border-dark rounded bg-surface-darker"
                        >
                            <span
                                class="text-[10px] text-text-secondary uppercase font-bold block"
                                >Currency</span
                            >
                            <span class="text-sm font-medium text-white"
                                >{society.currency}</span
                            >
                        </div>
                    </div>

                    <button
                        class="btn-secondary w-full justify-center mt-2 group-hover:border-primary group-hover:text-primary transition-colors"
                    >
                        Manage Configuration
                    </button>
                </div>
            {/each}
        </div>
    </div>
</div>
