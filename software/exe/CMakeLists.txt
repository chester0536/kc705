include_directories(../lib/core/include)

add_executable(ManagerTest src/ManagerTest.cxx)
target_link_libraries(ManagerTest ${JADE_CORE_LIBRARY})
list(APPEND INSTALL_TARGETS ManagerTest)

add_executable(OptionTest src/OptionTest.cxx)
target_link_libraries(OptionTest ${JADE_CORE_LIBRARY})
list(APPEND INSTALL_TARGETS OptionTest)

install(TARGETS ${INSTALL_TARGETS}
  DESTINATION bin
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib)
