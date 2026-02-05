<script lang="ts">
    import { fly, fade } from "svelte/transition";
    import { cubicOut } from "svelte/easing";

    // Mock Users
    let users = $state([
        {
            id: "u-001",
            name: "John Doe",
            email: "john@spaza.com",
            role: "admin",
            status: "active",
            last_login: "10m ago",
        },
        {
            id: "u-002",
            name: "Jane Smith",
            email: "jane@mcsk.or.ke",
            role: "cmo_admin",
            status: "active",
            last_login: "2h ago",
        },
        {
            id: "u-003",
            name: "Kelvin Mutua",
            email: "kelvin@kamp.or.ke",
            role: "analyst",
            status: "inactive",
            last_login: "3d ago",
        },
    ]);

    const roles = ["admin", "cmo_admin", "label_manager", "artist", "analyst"];

    let isCreateOpen = $state(false);
    let newUser = $state({ name: "", email: "", role: "analyst" });

    function handleAdd() {
        const id = `u-${(users.length + 1).toString().padStart(3, "0")}`;
        users = [
            { id, ...newUser, status: "active", last_login: "Never" } as any,
            ...users,
        ];
        isCreateOpen = false;
        newUser = { name: "", email: "", role: "analyst" };
    }

    function toggleStatus(id: string) {
        users = users.map((u) =>
            u.id === id
                ? {
                      ...u,
                      status: u.status === "active" ? "inactive" : "active",
                  }
                : u,
        );
    }

    function formatRole(role: string) {
        return role.replace("_", " ").toUpperCase();
    }
</script>

<svelte:head>
    <title>Users | Spaza Airplay</title>
</svelte:head>

<div
    class="flex flex-col h-full w-full relative bg-background-dark overflow-hidden"
>
    <header
        class="h-20 shrink-0 border-b border-border-dark bg-surface-dark/95 backdrop-blur-sm z-30 px-8 flex flex-col justify-center"
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
                class="text-[10px] font-bold uppercase tracking-widest text-text-muted"
                >Settings</span
            >
            <span class="material-symbols-outlined text-xs text-text-muted"
                >chevron_right</span
            >
            <span
                class="text-[10px] font-bold uppercase tracking-widest text-primary"
                >User Management</span
            >
        </nav>
        <div class="flex items-center justify-between">
            <h1 class="text-xl font-bold text-text-main tracking-tight">
                System Access & Users
            </h1>
            <button
                class="h-9 px-4 btn-primary rounded-lg flex items-center gap-2 font-bold uppercase tracking-widest text-[10px]"
                onclick={() => (isCreateOpen = true)}
            >
                <span class="material-symbols-outlined text-lg">person_add</span
                >
                Invite User
            </button>
        </div>
    </header>

    <main class="flex-1 overflow-auto p-8">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {#each users as user}
                <div
                    class="group bg-surface-darker/30 border border-border-dark/50 rounded-2xl p-6 hover:bg-surface-darker transition-all"
                >
                    <div class="flex justify-between items-start mb-6">
                        <div
                            class="size-12 rounded-full border-2 border-primary/20 bg-surface-dark flex items-center justify-center text-xl font-black text-text-main"
                        >
                            {user.name.charAt(0)}
                        </div>
                        <button
                            class="size-8 rounded-lg hover:bg-background-dark transition-colors"
                            onclick={() => toggleStatus(user.id)}
                        >
                            <span
                                class="size-2 rounded-full inline-block {user.status ===
                                'active'
                                    ? 'bg-emerald-500'
                                    : 'bg-red-500'}"
                            ></span>
                        </button>
                    </div>
                    <div>
                        <h3 class="font-bold text-text-main text-lg">
                            {user.name}
                        </h3>
                        <p class="text-xs text-text-muted mb-4">{user.email}</p>
                        <div class="flex flex-wrap gap-2">
                            <span
                                class="px-2 py-0.5 rounded-lg border border-border-dark bg-background-dark text-[9px] font-bold uppercase tracking-widest text-text-secondary"
                                >{formatRole(user.role)}</span
                            >
                            <span
                                class="px-2 py-0.5 rounded-lg bg-surface-dark text-[9px] font-mono text-text-muted"
                                >{user.last_login}</span
                            >
                        </div>
                    </div>
                </div>
            {/each}
        </div>
    </main>

    {#if isCreateOpen}
        <div
            class="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm"
            onclick={() => (isCreateOpen = false)}
            transition:fade
        ></div>
        <aside
            class="fixed top-2 bottom-2 right-2 w-[400px] bg-surface-dark border border-border-dark rounded-2xl z-50 p-8 space-y-6"
            transition:fly={{ x: 50, duration: 300, easing: cubicOut }}
        >
            <h2
                class="text-xl font-bold text-text-main uppercase tracking-tighter"
            >
                Invite Collaborator
            </h2>
            <div class="space-y-4">
                <input
                    type="text"
                    class="input w-full"
                    placeholder="Full Name"
                    bind:value={newUser.name}
                />
                <input
                    type="email"
                    class="input w-full"
                    placeholder="Email Address"
                    bind:value={newUser.email}
                />
                <select class="select w-full" bind:value={newUser.role}>
                    {#each roles as r}
                        <option value={r}>{formatRole(r)}</option>
                    {/each}
                </select>
            </div>
            <button
                class="w-full btn-primary py-4 rounded-xl font-bold uppercase tracking-widest"
                onclick={handleAdd}>Grant Access</button
            >
        </aside>
    {/if}
</div>

<style>
    .input {
        height: 2.75rem;
        background: #f8fafc;
        border: 1px solid #e2e8f0;
        border-radius: 0.75rem;
        padding: 0 1rem;
        color: #0f172a;
        font-size: 0.875rem;
    }
    .select {
        height: 2.75rem;
        background: #f8fafc;
        border: 1px solid #e2e8f0;
        border-radius: 0.75rem;
        padding: 0 1rem;
        color: #0f172a;
        appearance: none;
    }
</style>
