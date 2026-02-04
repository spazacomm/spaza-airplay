<script lang="ts">
    // Mock Rates
    const rates = [
        {
            id: "rt-01",
            name: "Commercial Radio (Tier 1)",
            type: "Per Play",
            amount: "KES 50.00",
            conditions: "Active 06:00 - 18:00",
        },
        {
            id: "rt-02",
            name: "Commercial Radio (Night)",
            type: "Per Play",
            amount: "KES 15.00",
            conditions: "Active 18:00 - 06:00",
        },
        {
            id: "rt-03",
            name: "Community Radio",
            type: "Per Play",
            amount: "KES 5.00",
            conditions: "All Day",
        },
        {
            id: "rt-04",
            name: "Nightclub / Bar",
            type: "Flat Fee",
            amount: "KES 2,000 / mo",
            conditions: "License B",
        },
    ];
</script>

<svelte:head>
    <title>Rates Engine | Spaza Airplay</title>
</svelte:head>

<div class="flex h-full flex-col overflow-hidden -m-4 md:-m-8">
    <div
        class="px-8 py-6 border-b border-border-dark shrink-0 bg-surface-darker"
    >
        <div class="flex justify-between items-end">
            <div>
                <h1 class="text-3xl font-bold tracking-tight text-white">
                    Rate Engine
                </h1>
                <p class="text-text-secondary mt-1">
                    Configure complex royalty calculation rules.
                </p>
            </div>
            <button class="btn-primary">
                <span class="material-symbols-outlined">add_circle</span>
                New Rule
            </button>
        </div>
    </div>

    <div class="flex-1 overflow-auto bg-surface-dark p-8">
        <div
            class="bg-surface-darker border border-border-dark rounded-xl overflow-hidden"
        >
            <table class="w-full text-left">
                <thead class="bg-background-dark border-b border-border-dark">
                    <tr>
                        <th
                            class="py-4 px-6 text-xs font-bold uppercase text-text-secondary"
                            >Rate Name</th
                        >
                        <th
                            class="py-4 px-6 text-xs font-bold uppercase text-text-secondary"
                            >Method</th
                        >
                        <th
                            class="py-4 px-6 text-xs font-bold uppercase text-text-secondary"
                            >Value</th
                        >
                        <th
                            class="py-4 px-6 text-xs font-bold uppercase text-text-secondary"
                            >Conditions</th
                        >
                        <th
                            class="py-4 px-6 text-xs font-bold uppercase text-text-secondary w-10"
                        ></th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-border-dark">
                    {#each rates as rate}
                        <tr
                            class="group hover:bg-surface-dark transition-colors"
                        >
                            <td class="py-4 px-6 font-medium text-white"
                                >{rate.name}</td
                            >
                            <td class="py-4 px-6">
                                <span
                                    class="badge border border-border-dark text-text-secondary bg-background-dark"
                                    >{rate.type}</span
                                >
                            </td>
                            <td
                                class="py-4 px-6 font-bold text-emerald-500 font-mono"
                                >{rate.amount}</td
                            >
                            <td class="py-4 px-6 text-sm text-text-secondary"
                                >{rate.conditions}</td
                            >
                            <td class="py-4 px-6 text-center">
                                <button
                                    class="text-text-muted hover:text-white"
                                >
                                    <span class="material-symbols-outlined"
                                        >edit</span
                                    >
                                </button>
                            </td>
                        </tr>
                    {/each}
                </tbody>
            </table>
        </div>

        <!-- Placeholder for Rule Builder Preview -->
        <div
            class="mt-8 p-6 border-2 border-dashed border-border-dark rounded-xl flex flex-col items-center justify-center text-center opacity-50 hover:opacity-100 transition-opacity"
        >
            <span
                class="material-symbols-outlined text-4xl text-text-secondary mb-2"
                >schema</span
            >
            <h3 class="text-lg font-bold text-white">Visual Rule Builder</h3>
            <p class="text-text-secondary max-w-md">
                Drag-and-drop logic builder for improved rate configuration
                coming soon.
            </p>
        </div>
    </div>
</div>
