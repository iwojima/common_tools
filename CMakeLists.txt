project(ELASTOS_GLOBEL)
cmake_minimum_required(VERSION 2.8)

include(CMakeParseArguments)                               #包含CMakeParseArguments cmake_parse_arguments()需要

#一些常量
set(CMAKE_C_COMPILER  g++)
set(CMAKE_AR          ar)
set(CMAKE_CP          cp)

set(WORK_ROOT_DIR "/home/iwojima/iWork/")
set(INC_DIR "/home/iwojima/iWork/include")
set(LIB_DIR "/home/iwojima/iWork/lib")

set(MIDDLE_FILE_EXT ".o")
set(DLL_FILE_EXT    ".eco")
set(LIB_FILE_EXT    ".lib")
set(EXE_FILE_EXT    ".ecx")

 #编译主函数
function(compile_command)                                                                        
	#获取键NAME ， TYPE ...等所对应的值
	set(multiValueArgs SRC_LST INCLUDES_DIR C_DEFINES)                                          
	set(oneValueArgs   NAME TYPE)
	cmake_parse_arguments(COMPILE_COMMAND "" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

	if(${COMPILE_COMMAND_TYPE} STREQUAL  eco)
		#如果编译类型是eco
		message("TYPE = eco")
	elseif(${COMPILE_COMMAND_TYPE} STREQUAL  lib)
		#如果编译类型是lib
		build_middle_file(SRC_LST ${COMPILE_COMMAND_SRC_LST} 
						MIDDLE_FILE LIST_MIDDLE_FILE
						DEPEND LIST_DEPEND 
						INCLUDES_DIR ${COMPILE_COMMAND_INCLUDES_DIR}
						C_DEFINES ${COMPILE_COMMAND_C_DEFINES})
		link_static_lib(NAME ${COMPILE_COMMAND_NAME} 
						MIDDLE_FILE ${LIST_MIDDLE_FILE} 
						DEPEND ${LIST_DEPEND})
	elseif(${COMPILE_COMMAND_TYPE} STREQUAL  ecx)
		#如果编译类型是ecx
	else()
		message("*ERROR* INVALID TARGET TYPE !!!")
	endif()
endfunction()

#添加依赖到all（不会重复新建all）
function(append_dependencies)
	set(multiValueArgs DEPENDENCIES)
	cmake_parse_arguments(APPEND_DEPENDENCIES "" "" "${multiValueArgs}" ${ARGN})
	
	get_target_property(OUTPUT_VALUE all STATUS)                               #判断all的STATUS属性是否存在
	if(${OUTPUT_VALUE} STREQUAL OUTPUT_VALUE-NOTFOUND) 
		#属性不存在，则新建all
		add_custom_target(all DEPENDS ${APPEND_DEPENDENCIES_DEPENDENCIES})
	    set_property(TARGET all PROPERTY STATUS AVAILABLE)
	else()
		#属性存在，则向all添加依赖
		add_dependencies(all DEPENDS ${APPEND_DEPENDENCIES_DEPENDENCIES})
	endif()
	
endfunction()

function(build_middle_file)
	
	set(multiValueArgs MIDDLE_FILE SRC_LST DEPEND INCLUDES_DIR C_DEFINES)
	cmake_parse_arguments(BUILD_MIDDLE_FILE "" "" "${multiValueArgs}" ${ARGN})

	set(MIDDLE_FILE)
	set(DEPEND_ITEM)
	set(INDEX 1)
	foreach(SRC_FILE ${BUILD_MIDDLE_FILE_SRC_LST})                     #遍历源文件列表
		get_filename_component(SRC_ABSOLUTE_PATH ${SRC_FILE} ABSOLUTE) #获取源文件绝对路径
		get_filename_component(FILENAME_WE ${SRC_FILE} NAME_WE)        #去掉源文件后缀名
		list(APPEND MIDDLE_FILE ${FILENAME_WE}${MIDDLE_FILE_EXT})      #累加中间o文件进List
		add_custom_target(BUILD_MIDDLE_FILE_${INDEX} 
						COMMAND ${CMAKE_C_COMPILER} ${BUILD_MIDDLE_FILE_C_DEFINES} -D_GNUC -c -o ${FILENAME_WE}${MIDDLE_FILE_EXT} ${SRC_ABSOLUTE_PATH} -I/home/iwojima/iWork/include ) #新建TARGET BUILD_MIDDLE_FILE_${INDEX}执行编译
		list(APPEND DEPEND_ITEM BUILD_MIDDLE_FILE_${INDEX})            #累加TARGET进List
		math(EXPR INDEX "${INDEX} + 1")
	endforeach()

	set(${BUILD_MIDDLE_FILE_MIDDLE_FILE} ${MIDDLE_FILE} PARENT_SCOPE)  #返回中间文件列表
	set(${BUILD_MIDDLE_FILE_DEPEND} ${DEPEND_ITEM} PARENT_SCOPE)       #返回TARGET列表

endfunction()

function(link_static_lib)
	
	set(multiValueArgs DEPEND MIDDLE_FILE)
	set(oneValueArgs   NAME)
	cmake_parse_arguments(LINK_STATIC_LIB "" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})	
	#新建TARGET LINK_STATIC_LIB ， 依赖于${LINK_STATIC_LIB_DEPEND} （即所有中间文件的TARGET）
	add_custom_target(LINK_STATIC_LIB COMMAND ${CMAKE_AR} -qv ${LINK_STATIC_LIB_NAME}${LIB_FILE_EXT} ${LINK_STATIC_LIB_MIDDLE_FILE} DEPENDS ${LINK_STATIC_LIB_DEPEND}) 
	
	#将LINK_STATIC_LIB作为all的依赖
	append_dependencies(DEPENDENCIES LINK_STATIC_LIB)

endfunction()

function(link_dymanic_lib)
	message("null !")
endfunction()

function(export_headers)
	cmake_parse_arguments(EXPORT_HEADERS "" "" "LIST_EXPORT_HEADERS" ${ARGN})
	
	set(HEADERS_ABSOLUTE_PATH)
	add_custom_target(EXPORT_HEADERS_${EXPORT_HEADERS_LIST_EXPORT_HEADERS})
	foreach(HEADER_FILE ${EXPORT_HEADERS_LIST_EXPORT_HEADERS})
		get_filename_component(HEADER_ABSOLUTE_PATH ${HEADER_FILE} ABSOLUTE)                                #获取源文件绝对路径
		list(APPEND HEADERS_ABSOLUTE_PATH ${HEADER_ABSOLUTE_PATH})                                          #将源文件路径加入HEADERS_ABSOLUTE_PATH
		add_custom_target(${HEADER_FILE} COMMAND ${CMAKE_CP} ${HEADER_ABSOLUTE_PATH} ${INC_DIR})            #新建TARGET ${HEADER_FILE}，执行cp
		append_dependencies(DEPENDENCIES ${HEADER_FILE})                                                    #将TARGET ${HEADER_FILE}加入all的依赖
	endforeach()
endfunction()
















