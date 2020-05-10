add_library(CImGui)

target_sources(CImGui PRIVATE
  cimgui.cpp
  imgui/imgui_demo.cpp
  imgui/imgui_draw.cpp
  imgui/imgui_widgets.cpp
  imgui/imgui.cpp
)

target_include_directories(CImGui PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include ${CMAKE_CURRENT_SOURCE_DIR}/../../ModuleMaps/CImGui)

install(TARGETS CImGui
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  RUNTIME DESTINATION bin
  COMPONENT lib)



