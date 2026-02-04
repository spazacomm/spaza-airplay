<script lang="ts">
    import type { PageData } from "./$types";

    let { data }: { data: PageData } = $props();

    const rightsHolders = [
        {
            id: "rh-001",
            name: "Sauti Sol",
            ipi: "00123456789",
            type: "artist", // writer, publisher, label, performer
            roles: ["Performer", "Writer"],
            worksCount: 45,
            status: "active",
        },
        {
            id: "rh-002",
            name: "Bien-Aime Baraza",
            ipi: "00654321987",
            type: "writer",
            roles: ["Composer", "Lyricist"],
            worksCount: 32,
            status: "active",
        },
        {
            id: "rh-003",
            name: "Universal Music Africa",
            ipi: "12345678901",
            type: "label",
            roles: ["Label", "Publisher"],
            worksCount: 150,
            status: "active",
        },
        {
            id: "rh-004",
            name: "Sol Generation Records",
            ipi: "09876543210",
            type: "publisher",
            roles: ["Publisher"],
            worksCount: 28,
            status: "active",
        },
    ];

    let selectedHolderId = $state("");
</script>

<svelte:head>
    <title>Rights Holders | Spaza Airplay</title>
</svelte:head>

<div class="flex h-full flex-col overflow-hidden -m-4 md:-m-8">
    <!-- Header -->
    <div
        class="px-8 py-6 border-b border-border-dark shrink-0 bg-surface-darker"
    >
        <div class="flex flex-col gap-6">
            <div class="flex flex-wrap gap-2 items-center text-sm">
                <a
                    class="text-text-secondary hover:text-primary transition-colors font-medium"
                    href="/dashboard">Dashboard</a
                >
                <span
                    class="material-symbols-outlined text-text-secondary text-sm"
                    >chevron_right</span
                >
                <a
                    class="text-text-secondary hover:text-primary transition-colors font-medium"
                    href="/catalogue/works">Catalogue</a
                >
                <span
                    class="material-symbols-outlined text-text-secondary text-sm"
                    >chevron_right</span
                >
                <span class="text-white font-semibold">Rights Holders</span>
            </div>
            <div class="flex justify-between items-end">
                <div>
                    <h1 class="text-3xl font-bold tracking-tight">
                        Rights Holders
                    </h1>
                    <p class="text-text-secondary mt-1">
                        Manage artists, writers, and publishers.
                    </p>
                </div>
                <button class="btn-primary">
                    <span class="material-symbols-outlined">person_add</span>
                    Add Entity
                </button>
            </div>
        </div>
    </div>

    <!-- Table -->
    <div class="flex-1 overflow-auto bg-surface-dark">
        <table class="w-full text-left border-collapse">
            <thead class="bg-surface-dark sticky top-0 z-10 shadow-sm">
                <tr>
                    <th
                        class="py-3 px-6 text-xs font-semibold uppercase tracking-wider text-text-secondary"
                        >Name</th
                    >
                    <th
                        class="py-3 px-6 text-xs font-semibold uppercase tracking-wider text-text-secondary"
                        >IPI Number</th
                    >
                    <th
                        class="py-3 px-6 text-xs font-semibold uppercase tracking-wider text-text-secondary"
                        >Roles</th
                    >
                    <th
                        class="py-3 px-6 text-xs font-semibold uppercase tracking-wider text-text-secondary text-right"
                        >Linked Works</th
                    >
                    <th
                        class="py-3 px-6 text-xs font-semibold uppercase tracking-wider text-text-secondary text-center"
                        >Status</th
                    >
                    <th
                        class="py-3 px-6 text-xs font-semibold uppercase tracking-wider text-text-secondary w-10"
                    ></th>
                </tr>
            </thead>
            <tbody class="divide-y divide-border-dark bg-surface-darker">
                {#each rightsHolders as holder}
                    <tr class="table-row group">
                        <td class="py-4 px-6">
                            <div class="flex items-center gap-3">
                                <div
                                    class="size-8 rounded-full bg-surface-dark flex items-center justify-center text-text-secondary border border-border-dark"
                                >
                                    <span
                                        class="material-symbols-outlined text-sm"
                                    >
                                        {holder.type === "label" ||
                                        holder.type === "publisher"
                                            ? "business"
                                            : "person"}
                                    </span>
                                </div>
                                <span class="font-bold text-white"
                                    >{holder.name}</span
                                >
                            </div>
                        </td>
                        <td
                            class="py-4 px-6 text-sm font-mono text-text-secondary"
                            >{holder.ipi}</td
                        >
                        <td class="py-4 px-6">
                            <div class="flex flex-wrap gap-1">
                                {#each holder.roles as role}
                                    <span
                                        class="badge bg-border-dark text-text-secondary border border-border-dark/50"
                                        >{role}</span
                                    >
                                {/each}
                            </div>
                        </td>
                        <td class="py-4 px-6 text-right font-medium"
                            >{holder.worksCount}</td
                        >
                        <td class="py-4 px-6 text-center">
                            <span
                                class="badge badge-success uppercase text-[10px]"
                                >Active</span
                            >
                        </td>
                        <td class="py-4 px-6 text-center">
                            <button
                                class="text-text-muted hover:text-white opacity-0 group-hover:opacity-100 transition-opacity"
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
</div>
