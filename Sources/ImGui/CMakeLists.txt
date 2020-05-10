add_library(ImGui)

target_sources(ImGui PRIVATE
  ImGui.swift
)
target_link_libraries(ImGui PRIVATE CImGui)

install(TARGETS ImGui
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  RUNTIME DESTINATION bin
  COMPONENT lib)



