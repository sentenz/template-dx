---
name: api-documentation
description: Adds Doxygen-compatible documentation comments to C++ header files. Use this skill exclusively for adding or improving API documentation in existing header files (*.hpp, *.h). Do NOT create new resource files such as Doxyfile, scripts, or README files.
metadata:
  version: "1.2"
  activation:
    implicit: true
    priority: 0
    triggers:
      - "doxygen"
      - "api documentation"
      - "document the API"
      - "add doc comments"
    match:
      # Prefer C/C++ related prompts and repository areas.
      languages: ["cpp", "c", "c++"]
      paths: ["src/**/*.hpp", "src/**/*.h", "include/**/*.hpp", "include/**/*.h"]
      prompt_regex: "(?i)(api doc|doxygen|document the API|api documentation|doc comments)"
  usage:
    load_on_prompt: true
    autodispatch: true
---

# API Documentation

Instructions for AI coding agents on adding Doxygen-compatible documentation comments to C++ header files.

> [!NOTE]
> This skill is for documenting header files only. Do NOT create new resource files (e.g., Doxyfile, scripts, README).

- [1. Benefits](#1-benefits)
- [2. Principles](#2-principles)
  - [2.1. Documentation Principles](#21-documentation-principles)
  - [2.2. Documentation Hierarchy](#22-documentation-hierarchy)
- [3. Patterns](#3-patterns)
  - [3.1. File Documentation](#31-file-documentation)
  - [3.2. Class Documentation](#32-class-documentation)
  - [3.3. Function Documentation](#33-function-documentation)
  - [3.4. Member Documentation](#34-member-documentation)
  - [3.5. Grouping and Modules](#35-grouping-and-modules)
- [4. Workflow](#4-workflow)
- [5. Style Guide](#5-style-guide)
- [6. Template](#6-template)
  - [6.1. File Header Template](#61-file-header-template)
  - [6.2. Class Template](#62-class-template)
  - [6.3. Function Template](#63-function-template)
  - [6.4. Member Variable Template](#64-member-variable-template)
  - [6.5. Enum Template](#65-enum-template)
  - [6.6. Module/Group Template](#66-modulegroup-template)
- [7. References](#7-references)

## 1. Benefits

- Discoverability
  > Well-documented APIs enable developers to quickly understand and use components without reading implementation details.

- Consistency
  > Consistent documentation reduces onboarding time and helps maintainers understand design decisions and constraints.

- Maintainability
  > Documentation embedded in source code stays synchronized with implementation, reducing drift between code and documentation.

- Traceability
  > Documentation comments serve as living specifications, keeping API contracts synchronized with implementation.

## 2. Principles

### 2.1. Documentation Principles

Effective API documentation follows these core principles.

- Complete
  > Document all public APIs including classes, functions, parameters, return values, and exceptions. Private implementation details may be omitted.

- Accurate
  > Documentation must match the actual behavior. Update documentation whenever the implementation changes.

- Concise
  > Use clear, brief descriptions. Avoid redundant information that restates what is obvious from the signature.

- Actionable
  > Include usage examples, preconditions, postconditions, and error handling to help developers use the API correctly.

- Consistent
  > Follow the same style and structure throughout the codebase using the patterns defined in this skill.

### 2.2. Documentation Hierarchy

The documentation hierarchy ensures comprehensive coverage at all levels.

- File Level
  > Every header file should have a file-level comment describing its purpose, author, and license.

- Class Level
  > Each class or struct should have a brief description explaining its responsibility and usage context.

- Function Level
  > Public functions require documentation of parameters, return values, exceptions, and preconditions/postconditions.

- Member Level
  > Non-trivial member variables should have inline comments explaining their purpose.

## 3. Patterns

### 3.1. File Documentation

File-level documentation provides context for the entire file.

- Purpose
  > Describes the file's role in the project architecture.

- Author
  > Identifies the original author(s) of the file.

- License
  > Specifies the licensing terms (typically SPDX identifier).

### 3.2. Class Documentation

Class-level documentation describes the abstraction.

- Brief
  > A one-line summary of what the class represents.

- Details
  > Extended description of responsibilities, invariants, and usage patterns.

- Template Parameters
  > For template classes, document each template parameter's purpose and constraints.

### 3.3. Function Documentation

Function-level documentation describes the contract.

- Brief
  > A one-line summary of what the function does.

- Parameters
  > Document each parameter with `@param` including direction (`[in]`, `[out]`, `[in,out]`).

- Return Value
  > Document the return value with `@return` or `@retval` for specific values.

- Exceptions
  > Document thrown exceptions with `@throws` or `@exception`.

- Preconditions
  > Document preconditions with `@pre`.

- Postconditions
  > Document postconditions with `@post`.

### 3.4. Member Documentation

Member-level documentation clarifies data semantics.

- Inline Comments
  > Use `///< description` for trailing inline documentation.

- Block Comments
  > Use `/// description` for preceding documentation.

### 3.5. Grouping and Modules

Organize related elements into logical groups.

- Defgroups
  > Use `@defgroup` to create named documentation modules.

- Ingroups
  > Use `@ingroup` to add elements to existing groups.

- Memberof
  > Use `@memberof` for explicit class membership.

## 4. Workflow

> [!IMPORTANT]
> Do NOT create Doxyfile, scripts, or other resource files. Only modify header files.

1. Identify

    Identify undocumented or poorly documented public APIs in header files (e.g., `src/<module>/<header>.hpp`).

2. Add Documentation Comments

    Add Doxygen-compatible documentation comments directly to header files following the templates below.

3. Documentation Coverage Requirements

    Include comprehensive documentation for:

    - All public classes, structs, and enums
    - All public and protected member functions
    - All function parameters and return values
    - All template parameters
    - Exception specifications
    - Thread safety guarantees when applicable
    - Complexity guarantees for algorithms

4. Apply Templates

    Structure all documentation using the template patterns below.

5. Review

    Review documentation for accuracy and readability.

## 5. Style Guide

Doxygen supports multiple comment styles. Use the Javadoc style for consistency.

- Language
  > Write documentation in clear, concise English. Use present tense for descriptions ("Returns the sum" not "Will return the sum").

- Line Length
  > Keep documentation lines under 100 characters for readability.

- Block Comments
  > Use `/** ... */` for multi-line documentation blocks. Each line within the block should start with ` * `.

- Comment Style
  > Prefer `///` for single-line documentation and `/** */` for multi-line documentation blocks. Use Javadoc-style commands (`@param`, `@return`) rather than Qt-style (`\param`, `\return`).

- Brief Descriptions
  > Use `@brief` for explicit brief descriptions.

- Detailed Descriptions
  > Add detailed descriptions after the brief, separated by a blank line or using `@details`.

- Parameter Direction
  > Always specify parameter direction using `[in]`, `[out]`, or `[in,out]` for clarity.

- Code Examples
  > Use `@code` and `@endcode` blocks for usage examples within documentation.

- Cross-References
  > Use `@see` to reference related functions, classes, or external resources.

- Warnings and Notes
  > Use `@note` for important information and `@warning` for critical warnings.

- Deprecation
  > Mark deprecated APIs with `@deprecated` including migration guidance.

- TODO Items
  > Use `@todo` for planned improvements visible in generated documentation.

- Order of Tags
  > Follow this order for function documentation:
  > 1. `@brief`
  > 2. `@details` (if needed)
  > 3. `@tparam` (for templates)
  > 4. `@param`
  > 5. `@return`
  > 6. `@throws`
  > 7. `@pre`
  > 8. `@post`
  > 9. `@note`
  > 10. `@warning`
  > 11. `@see`
  > 12. `@deprecated`

## 6. Template

Use these templates for new documentation. Replace placeholders with actual values.

### 6.1. File Header Template

> [!NOTE]
> Place the `@file` block **after** the include guard (`#pragma once` or `#ifndef`/`#define`). This ensures the documentation is parsed once along with the declarations it describes and keeps preprocessor directives separate from API documentation.

```cpp
#pragma once

/**
 * @file <filename>.hpp
 * @brief Brief one-line description of the file's purpose.
 *
 * Detailed description of the file's contents, design decisions,
 * and any important notes for developers.
 *
 * @author <author>
 * @author <author_name>
 * @copyright Copyright (c) <year> <organization>
 * @license SPDX-License-Identifier: LicenseRef-Proprietary
 */
```

### 6.2. Class Template

```cpp
/**
 * @brief Brief one-line description of the class.
 *
 * Detailed description of the class including:
 * - Its responsibility and role in the system
 * - Key invariants maintained by the class
 * - Thread safety guarantees
 * - Example usage patterns
 *
 * @code
 * ClassName obj;
 * obj.method(param);
 * @endcode
 *
 * @tparam T Description of template parameter T.
 *
 * @see RelatedClass
 * @since 1.0
 */
template <typename T>
class ClassName
{
  // ...
};
```

### 6.3. Function Template

```cpp
/**
 * @brief Brief one-line description of what the function does.
 *
 * Detailed description of the function including algorithm details,
 * edge cases, and usage notes.
 *
 * @param[in] param1 Description of the first input parameter.
 * @param[out] param2 Description of the output parameter.
 * @param[in,out] param3 Description of bidirectional parameter.
 *
 * @return Description of the return value.
 * @retval specific_value Meaning of this specific return value.
 *
 * @throws std::invalid_argument If param1 is invalid.
 * @throws std::runtime_error If operation fails.
 *
 * @pre Preconditions that must be met before calling.
 * @post Postconditions guaranteed after successful execution.
 *
 * @note Any important notes for users.
 * @warning Any warnings about potential misuse.
 *
 * @complexity O(n) where n is the size of param1.
 *
 * @see relatedFunction()
 *
 * @code
 * auto result = functionName(input, output);
 * @endcode
 *
 * @see relatedFunction
 */
ReturnType functionName(const InputType& param1, OutputType& param2);
```

### 6.4. Member Variable Template

```cpp
class ClassName
{
private:
  int count_;       ///< Number of items currently stored (inline-line style).
  bool is_valid_;   ///< Whether the object is in a valid state (inline-line style).

  /// Brief description for simple members (single-line style).
  int simple_member_;

  /**
   * @brief Buffer for temporary storage.
   *
   * Detailed explanation of the member's purpose, lifetime,
   * and any synchronization requirements.
   */
  std::vector<char> buffer_;
};
```

### 6.5. Enum Template

```cpp
/**
 * @brief Brief description of what this enumeration represents.
 *
 * Detailed description of the enum's purpose and usage context.
 */
enum class EnumName
{
  Success,     ///< Description, e.g. Operation completed successfully.
  Error,       ///< Description, e.g. Operation failed with an error.
  Pending,     ///< Description, e.g. Operation is still in progress.
  NotFound     ///< Description, e.g. Requested item was not found.
};
```

### 6.6. Module/Group Template

```cpp
/**
 * @defgroup module_name Module Display Name
 * @brief Brief one-line description of the module/group.
 *
 * Detailed description of the module/group purpose, components.
 *
 * @{
 */

// Classes and functions belonging to this group

/** @} */ // End of module_name
```

## 7. References

- Doxygen [Manual](https://www.doxygen.nl/manual/) guide.
- Doxygen [Commands](https://www.doxygen.nl/manual/commands.html) reference.
- Doxygen [Configuration](https://www.doxygen.nl/manual/config.html) reference.
- Google C++ Style Guide [Comments](https://google.github.io/styleguide/cppguide.html#Comments) section.
