Convert the below HTML/CSS code into React component. Do not include the global components as these already exist:

<div id="app-container" class="relative mx-auto h-full min-h-screen w-full max-w-[390px] bg-white text-slate-800 shadow-2xl overflow-hidden font-sans">
    
    <!-- Header Section -->
    <header id="header-mobile" class="pt-12 pb-4 px-6 flex items-center justify-between bg-white relative z-10">
        <div class="w-8"></div> <!-- Spacer for centering -->
        <h1 class="text-2xl font-bold text-slate-900 tracking-tight">Crear Usuario</h1>
        <div class="w-8 flex justify-end">
            <div class="relative">
                <i class="fa-solid fa-house text-2xl text-blue-600"></i>
                <i class="fa-solid fa-wifi text-xs text-pink-500 absolute -top-1 -right-1 bg-white rounded-full border border-white"></i>
            </div>
        </div>
    </header>

    <!-- Tabs Navigation -->
    <nav id="tab-bar" class="w-full px-4 mt-2">
        <div class="flex items-end space-x-1 relative z-10 pl-2">
            <!-- Active Tab -->
            <button class="bg-[#6A1B9A] text-white px-6 py-2 rounded-t-2xl font-medium text-sm shadow-sm relative top-[1px] z-20">
                Dispositivos
            </button>
            <!-- Inactive Tabs -->
            <button class="bg-gray-400 text-white px-8 py-2 rounded-t-2xl font-medium text-sm shadow-inner hover:bg-gray-500 transition-colors">
                Otros
            </button>
            <button class="bg-gray-300 text-slate-600 px-8 py-2 rounded-t-2xl font-bold text-lg shadow-inner hover:bg-gray-400 transition-colors">
                +
            </button>
        </div>
        <!-- Purple Line -->
        <div class="h-1.5 w-full bg-[#6A1B9A] rounded-full relative z-10 shadow-sm"></div>
    </nav>

    <!-- Main Content: List -->
    <main id="main-content" class="px-6 py-8 h-[45vh] overflow-y-auto relative pr-2">
        <!-- Custom Scrollbar Track Visual -->
        <div class="absolute right-1 top-8 bottom-8 w-1.5 bg-gray-100 rounded-full overflow-hidden">
            <div class="h-1/3 w-full bg-gray-400 rounded-full mt-4"></div>
        </div>

        <div class="space-y-3 pr-4">
            <!-- Item 1 -->
            <div id="card-device-1" class="flex items-center justify-between bg-gray-300/80 px-4 py-3 rounded-lg shadow-sm border border-gray-300/50 backdrop-blur-sm">
                <span class="font-medium text-slate-800">Puerta principal</span>
                <i class="fa-solid fa-house-signal text-blue-600 text-sm"></i>
            </div>

            <!-- Item 2 -->
            <div id="card-device-2" class="flex items-center justify-between bg-gray-100 px-4 py-3 rounded-lg border border-gray-100">
                <span class="font-medium text-slate-700">Casa de playa</span>
            </div>

            <!-- Item 3 -->
            <div id="card-device-3" class="flex items-center justify-between bg-gray-300/80 px-4 py-3 rounded-lg shadow-sm border border-gray-300/50">
                <span class="font-medium text-slate-800">Cochera #1</span>
            </div>

            <!-- Item 4 -->
            <div id="card-device-4" class="flex items-center justify-between bg-gray-100 px-4 py-3 rounded-lg border border-gray-100">
                <span class="font-medium text-slate-700">Dispositivo A</span>
            </div>

            <!-- Item 5 -->
            <div id="card-device-5" class="flex items-center justify-between bg-gray-300/80 px-4 py-3 rounded-lg shadow-sm border border-gray-300/50">
                <span class="font-medium text-slate-800">Dispositivo B</span>
            </div>

            <!-- Item 6 -->
            <div id="card-device-6" class="flex items-center justify-between bg-gray-100 px-4 py-3 rounded-lg border border-gray-100">
                <span class="font-medium text-slate-700">ETC</span>
            </div>
             <!-- Item 7 (Hidden overflow demo) -->
            <div class="flex items-center justify-between bg-gray-300/80 px-4 py-3 rounded-lg shadow-sm border border-gray-300/50 opacity-50">
                <span class="font-medium text-slate-800">Dispositivo C</span>
            </div>
        </div>
    </main>

    <!-- Bottom Control Panel -->
    <section id="section-controls" class="absolute bottom-8 left-0 w-full px-4">
        <div class="bg-gray-200 rounded-[2rem] p-6 shadow-[inset_0_2px_4px_rgba(0,0,0,0.06)] border border-gray-100">
            <div class="flex justify-between items-end px-2">
                
                <!-- Abrir Button -->
                <div class="flex flex-col items-center gap-2">
                    <button class="w-14 h-14 rounded-full bg-gradient-to-b from-white to-gray-100 shadow-[0_4px_6px_-1px_rgba(0,0,0,0.1),0_2px_4px_-1px_rgba(0,0,0,0.06),inset_0_-2px_4px_rgba(0,0,0,0.05)] flex items-center justify-center active:scale-95 transition-transform border border-white">
                        <div class="w-10 h-10 rounded-full bg-gray-50 flex items-center justify-center shadow-inner">
                            <i class="fa-solid fa-arrow-right-to-bracket text-green-500 text-xl"></i>
                        </div>
                    </button>
                    <span class="text-xs font-bold text-gray-400 uppercase tracking-wide">Abrir</span>
                </div>

                <!-- Pausa Button -->
                <div class="flex flex-col items-center gap-2">
                    <button class="h-14 w-10 rounded-full bg-gradient-to-b from-white to-gray-100 shadow-[0_4px_6px_-1px_rgba(0,0,0,0.1),0_2px_4px_-1px_rgba(0,0,0,0.06),inset_0_-2px_4px_rgba(0,0,0,0.05)] flex items-center justify-center active:scale-95 transition-transform border border-white">
                        <div class="flex gap-1">
                            <div class="w-1 h-5 bg-gray-400 rounded-full shadow-sm"></div>
                            <div class="w-1 h-5 bg-gray-400 rounded-full shadow-sm"></div>
                        </div>
                    </button>
                    <span class="text-xs font-bold text-gray-400 uppercase tracking-wide">Pausa</span>
                </div>

                <!-- Cerrar Button -->
                <div class="flex flex-col items-center gap-2">
                    <button class="w-14 h-14 rounded-full bg-gradient-to-b from-white to-gray-100 shadow-[0_4px_6px_-1px_rgba(0,0,0,0.1),0_2px_4px_-1px_rgba(0,0,0,0.06),inset_0_-2px_4px_rgba(0,0,0,0.05)] flex items-center justify-center active:scale-95 transition-transform border border-white">
                        <div class="w-10 h-10 rounded-full bg-gray-50 flex items-center justify-center shadow-inner">
                            <i class="fa-solid fa-arrow-right-from-bracket text-orange-500 text-xl transform rotate-180"></i>
                        </div>
                    </button>
                    <span class="text-xs font-bold text-gray-400 uppercase tracking-wide">Cerrar</span>
                </div>

                <!-- Peatonal Button -->
                <div class="flex flex-col items-center gap-2">
                    <button class="w-14 h-14 flex items-center justify-center active:scale-95 transition-transform">
                        <i class="fa-solid fa-person-walking text-cyan-500 text-4xl drop-shadow-sm"></i>
                    </button>
                    <span class="text-xs font-bold text-gray-400 uppercase tracking-wide">Peatonal</span></div></div></div></section></div>