# SwiftImGui

Swift wrappers for [Dear ImGui](https://github.com/ocornut/imgui)

At the moment, the Swift wrappers are written/maintained manually, and the [CImGui](https://github.com/cimgui/cimgui) generated source is hand-tweaked (defining ImVec types to map to Swift SIMD types and removing variadic functions). There's also a very early prototype of a generator present in the repository, but that is currently unused.
