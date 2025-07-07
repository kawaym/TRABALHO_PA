// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DegreeSystem {
    struct Student {
        string privateName;
        uint enrollment;
        bool itExists;
    }

    mapping(uint => Student) public students;

    event StudentRegistered(
        uint indexed enrollment,
        address indexed sender_addr
    );

    modifier onlyStudent(uint enrollment) {
        require(students[enrollment].itExists, "Student not found");
        require(msg.sender != address(0), "Invalid address");
        _;
    }

    function RegisterStudent(uint enrollment, string memory name) external {
        require(!students[enrollment].itExists, "Student already registered");
        require(bytes(name).length > 0, "Name cannot be empty");

        students[enrollment] = Student({
            privateName: name,
            enrollment: enrollment,
            itExists: true
        });

        emit StudentRegistered(enrollment, msg.sender);
    }
}
