<script lang="ts">
	// Props
	let { title = "" }: { title?: string } = $props();
</script>

<header
	class="h-16 border-b border-border-dark flex items-center justify-between px-6 bg-surface-darker/95 backdrop-blur z-10"
>
	<!-- Mobile Menu Trigger -->
	<button class="md:hidden text-text-secondary mr-4">
		<span class="material-symbols-outlined">menu</span>
	</button>

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
	<div class="flex items-center gap-4 ml-auto">
		<!-- Notifications -->
		<button
			class="relative p-2 rounded-full hover:bg-white/5 text-text-secondary transition-colors"
		>
			<span class="material-symbols-outlined">notifications</span>
			<span
				class="absolute top-2 right-2 size-2 bg-primary rounded-full border-2 border-surface-darker"
			></span>
		</button>

		<!-- Upload Button -->
		<button class="btn-primary hidden sm:flex">
			<span class="material-symbols-outlined text-[20px]">upload</span>
			<span>Upload Track</span>
		</button>
	</div>
</header>
