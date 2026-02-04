<script lang="ts">
	// Props
	let { title = "" }: { title?: string } = $props();
</script>

<header
	class="h-16 border-b border-border-dark flex items-center justify-between px-6 bg-surface-darker/95 backdrop-blur z-10"
>
	<!-- Mobile Menu Trigger -->
	<div class="md:hidden flex items-center gap-4 mr-4">
		<button class="text-text-secondary">
			<span class="material-symbols-outlined">menu</span>
		</button>
		<img
			src="/logo-icon.png"
			alt="Spaza Airplay"
			class="size-8 object-contain"
		/>
	</div>

	<!-- Search -->
	<div class="flex-1 max-w-md hidden md:block">
		<div class="relative group">
			<span
				class="material-symbols-outlined absolute left-3 top-2.5 text-text-secondary group-focus-within:text-primary transition-colors pointer-events-none"
			>
				search
			</span>
			<input
				type="text"
				class="w-full bg-surface-dark border-none rounded-lg py-2.5 pl-10 pr-4 text-sm text-white placeholder:text-text-secondary focus:ring-1 focus:ring-primary transition-all"
				placeholder="Search songs, albums, or ISRC..."
			/>
		</div>
	</div>

	<!-- Page Title (Mobile) -->
	{#if title}
		<h2 class="md:hidden text-lg font-bold">{title}</h2>
	{/if}

	<!-- Actions -->
</header>
