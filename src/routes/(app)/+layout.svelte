<script lang="ts">
    import Sidebar from "$lib/components/layout/Sidebar.svelte";
    import Header from "$lib/components/layout/Header.svelte";

    let { children } = $props();
</script>

<div class="flex h-screen overflow-hidden bg-background-dark">
    <!-- Sidebar -->
    <Sidebar />

    <!-- Main Content Area -->
    <main class="flex-1 flex flex-col h-full overflow-hidden">
        <!-- Header -->
        <Header />

        <!-- Page Content -->
        <div class="flex-1 overflow-y-auto p-4 md:p-8">
            {@render children()}
        </div>
    </main>
</div>
