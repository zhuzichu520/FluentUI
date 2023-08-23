if(__get_git_revision_description)
    return()
endif()
set(__get_git_revision_description YES)

get_filename_component(_gitdescmoddir ${CMAKE_CURRENT_LIST_FILE} PATH)

function(_git_find_closest_git_dir _start_dir _git_dir_var)
    set(cur_dir "${_start_dir}")
    set(git_dir "${_start_dir}/.git")
    while(NOT EXISTS "${git_dir}")
        set(git_previous_parent "${cur_dir}")
        get_filename_component(cur_dir ${cur_dir} DIRECTORY)
        if(cur_dir STREQUAL git_previous_parent)
            set(${_git_dir_var}
                ""
                PARENT_SCOPE)
            return()
        endif()
        set(git_dir "${cur_dir}/.git")
    endwhile()
    set(${_git_dir_var}
        "${git_dir}"
        PARENT_SCOPE)
endfunction()

function(get_git_head_revision _refspecvar _hashvar)
    _git_find_closest_git_dir("${CMAKE_CURRENT_SOURCE_DIR}" GIT_DIR)

    if("${ARGN}" STREQUAL "ALLOW_LOOKING_ABOVE_CMAKE_SOURCE_DIR")
        set(ALLOW_LOOKING_ABOVE_CMAKE_SOURCE_DIR TRUE)
    else()
        set(ALLOW_LOOKING_ABOVE_CMAKE_SOURCE_DIR FALSE)
    endif()
    if(NOT "${GIT_DIR}" STREQUAL "")
        file(RELATIVE_PATH _relative_to_source_dir "${CMAKE_SOURCE_DIR}"
             "${GIT_DIR}")
        if("${_relative_to_source_dir}" MATCHES "[.][.]" AND NOT ALLOW_LOOKING_ABOVE_CMAKE_SOURCE_DIR)
            set(GIT_DIR "")
        endif()
    endif()
    if("${GIT_DIR}" STREQUAL "")
        set(${_refspecvar}
            "GITDIR-NOTFOUND"
            PARENT_SCOPE)
        set(${_hashvar}
            "GITDIR-NOTFOUND"
            PARENT_SCOPE)
        return()
    endif()

    if(NOT IS_DIRECTORY ${GIT_DIR})
        execute_process(
            COMMAND "${GIT_EXECUTABLE}" rev-parse
                    --show-superproject-working-tree
            WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
            OUTPUT_VARIABLE out
            ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE)
        if(NOT "${out}" STREQUAL "")
            file(READ ${GIT_DIR} submodule)
            string(REGEX REPLACE "gitdir: (.*)$" "\\1" GIT_DIR_RELATIVE
                                 ${submodule})
            string(STRIP ${GIT_DIR_RELATIVE} GIT_DIR_RELATIVE)
            get_filename_component(SUBMODULE_DIR ${GIT_DIR} PATH)
            get_filename_component(GIT_DIR ${SUBMODULE_DIR}/${GIT_DIR_RELATIVE}
                                   ABSOLUTE)
            set(HEAD_SOURCE_FILE "${GIT_DIR}/HEAD")
        else()
            file(READ ${GIT_DIR} worktree_ref)
            string(REGEX REPLACE "gitdir: (.*)$" "\\1" git_worktree_dir
                                 ${worktree_ref})
            string(STRIP ${git_worktree_dir} git_worktree_dir)
            _git_find_closest_git_dir("${git_worktree_dir}" GIT_DIR)
            set(HEAD_SOURCE_FILE "${git_worktree_dir}/HEAD")
        endif()
    else()
        set(HEAD_SOURCE_FILE "${GIT_DIR}/HEAD")
    endif()
    set(GIT_DATA "${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/git-data")
    if(NOT EXISTS "${GIT_DATA}")
        file(MAKE_DIRECTORY "${GIT_DATA}")
    endif()

    if(NOT EXISTS "${HEAD_SOURCE_FILE}")
        return()
    endif()
    set(HEAD_FILE "${GIT_DATA}/HEAD")
    configure_file("${HEAD_SOURCE_FILE}" "${HEAD_FILE}" COPYONLY)

    configure_file("${_gitdescmoddir}/GetGitRevisionDescription.cmake.in"
                   "${GIT_DATA}/grabRef.cmake" @ONLY)
    include("${GIT_DATA}/grabRef.cmake")

    set(${_refspecvar}
        "${HEAD_REF}"
        PARENT_SCOPE)
    set(${_hashvar}
        "${HEAD_HASH}"
        PARENT_SCOPE)
endfunction()

function(git_latest_tag _var)
    if(NOT GIT_FOUND)
        find_package(Git QUIET)
    endif()
    if(NOT GIT_FOUND)
        set(${_var}
            "GIT-NOTFOUND"
            PARENT_SCOPE)
        return()
    endif()
    execute_process(
        COMMAND "${GIT_EXECUTABLE}" describe --abbrev=0 --tag
        WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
        RESULT_VARIABLE res
        OUTPUT_VARIABLE out
        ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE)
    if(NOT res EQUAL 0)
        set(out "GIT-TAG-NOTFOUND")
    endif()

    set(${_var}
        "${out}"
        PARENT_SCOPE)
endfunction()

function(git_commit_counts _var)
    if(NOT GIT_FOUND)
        find_package(Git QUIET)
    endif()
    if(NOT GIT_FOUND)
        set(${_var}
            "GIT-NOTFOUND"
            PARENT_SCOPE)
        return()
    endif()
    execute_process(
        COMMAND "${GIT_EXECUTABLE}" rev-list HEAD --count
        WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
        RESULT_VARIABLE res
        OUTPUT_VARIABLE out
        ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE)
    if(NOT res EQUAL 0)
        set(out "GIT-TAG-NOTFOUND")
    endif()

    set(${_var}
        "${out}"
        PARENT_SCOPE)
endfunction()

function(git_describe _var)
    if(NOT GIT_FOUND)
        find_package(Git QUIET)
    endif()
    get_git_head_revision(refspec hash ALLOW_LOOKING_ABOVE_CMAKE_SOURCE_DIR)
    if(NOT GIT_FOUND)
        set(${_var}
            "GIT-NOTFOUND"
            PARENT_SCOPE)
        return()
    endif()
    if(NOT hash)
        set(${_var}
            "HEAD-HASH-NOTFOUND"
            PARENT_SCOPE)
        return()
    endif()

    execute_process(
        COMMAND "${GIT_EXECUTABLE}" describe --tags --always ${hash} ${ARGN}
        WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
        RESULT_VARIABLE res
        OUTPUT_VARIABLE out
        ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE)
    if(NOT res EQUAL 0)
        set(out "${out}-${res}-NOTFOUND")
    endif()

    set(${_var}
        "${out}"
        PARENT_SCOPE)
endfunction()

function(git_release_version _var)
    if(NOT GIT_FOUND)
        find_package(Git QUIET)
    endif()
    get_git_head_revision(refspec hash ALLOW_LOOKING_ABOVE_CMAKE_SOURCE_DIR)
    if(NOT GIT_FOUND)
        set(${_var}
            "GIT-NOTFOUND"
            PARENT_SCOPE)
        return()
    endif()
    if(NOT hash)
        set(${_var}
            "HEAD-HASH-NOTFOUND"
            PARENT_SCOPE)
        return()
    endif()

    execute_process(
        COMMAND "${GIT_EXECUTABLE}" symbolic-ref --short -q HEAD
        WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
        RESULT_VARIABLE res
        OUTPUT_VARIABLE out
        ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE)
    if(NOT res EQUAL 0)
        set(out "${out}-${res}-NOTFOUND")
    endif()

    string(FIND ${out} "release/" found})
    if(${out} MATCHES "^release/.+$")
        string(REPLACE "release/" "" tmp_out ${out})
        set(${_var} "${tmp_out}" PARENT_SCOPE)
    else()
        set(${_var} "" PARENT_SCOPE)
    endif()
endfunction()

function(git_describe_working_tree _var)
    if(NOT GIT_FOUND)
        find_package(Git QUIET)
    endif()
    if(NOT GIT_FOUND)
        set(${_var}
            "GIT-NOTFOUND"
            PARENT_SCOPE)
        return()
    endif()

    execute_process(
        COMMAND "${GIT_EXECUTABLE}" describe --dirty ${ARGN}
        WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
        RESULT_VARIABLE res
        OUTPUT_VARIABLE out
        ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE)
    if(NOT res EQUAL 0)
        set(out "${out}-${res}-NOTFOUND")
    endif()

    set(${_var}
        "${out}"
        PARENT_SCOPE)
endfunction()

function(git_get_exact_tag _var)
    git_describe(out --exact-match ${ARGN})
    set(${_var}
        "${out}"
        PARENT_SCOPE)
endfunction()

function(git_local_changes _var)
    if(NOT GIT_FOUND)
        find_package(Git QUIET)
    endif()
    get_git_head_revision(refspec hash)
    if(NOT GIT_FOUND)
        set(${_var}
            "GIT-NOTFOUND"
            PARENT_SCOPE)
        return()
    endif()
    if(NOT hash)
        set(${_var}
            "HEAD-HASH-NOTFOUND"
            PARENT_SCOPE)
        return()
    endif()

    execute_process(
        COMMAND "${GIT_EXECUTABLE}" diff-index --quiet HEAD --
        WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
        RESULT_VARIABLE res
        OUTPUT_VARIABLE out
        ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE)
    if(res EQUAL 0)
        set(${_var}
            "CLEAN"
            PARENT_SCOPE)
    else()
        set(${_var}
            "DIRTY"
            PARENT_SCOPE)
    endif()
endfunction()

git_release_version(GIT_TAG)
git_get_exact_tag(GIT_EXACT_TAG)
if(GIT_TAG STREQUAL "")
    git_latest_tag(GIT_TAG)
endif()
git_describe(GIT_DESCRIBE)
git_commit_counts(GIT_COMMIT_COUNT)
_git_find_closest_git_dir("${CMAKE_CURRENT_SOURCE_DIR}" GIT_DIR)
if(NOT IS_DIRECTORY ${GIT_DIR})
   message(".git not exist")
  set(GIT_COMMIT_COUNT "1")
  set(GIT_DESCRIBE "1.0.0")
  set(GIT_TAG "1.0.0")
else()
  message(".git exist")
endif()
string(REPLACE "." "," GIT_TAG_WITH_COMMA ${GIT_TAG})
string(REGEX MATCH "[0-9]+\\.[0-9]+\\.[0-9]+" GIT_SEMVER "${GIT_TAG}")
string(REGEX MATCH "([0-9]+)\\.([0-9]+)\\.([0-9]+)" SEMVER_SPLITED "${GIT_SEMVER}")
set(MAJOR_VERSION ${CMAKE_MATCH_1})
set(MINOR_VERSION ${CMAKE_MATCH_2})
set(PATCH_VERSION ${CMAKE_MATCH_3})
MATH(EXPR VERSION_COUNTER "${MAJOR_VERSION} * 10000 + ${MINOR_VERSION} * 100 + ${PATCH_VERSION}")
message(STATUS "Current git tag: ${GIT_TAG}, commit count: ${GIT_COMMIT_COUNT}, describe: ${GIT_DESCRIBE}")
message(STATUS "Current semver: major: ${MAJOR_VERSION}, minor: ${MINOR_VERSION}, patch: ${PATCH_VERSION}, counter: ${VERSION_COUNTER}")
