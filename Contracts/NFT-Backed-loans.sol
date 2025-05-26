// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LoanRequestContract {
    enum RequestStatus { Pending, Approved, Rejected, Cancelled }

    struct LoanRequest {
        uint256 amount;
        uint256 tenure;
        uint256 interestRate;
        address borrower;
        RequestStatus status;
    }

    LoanRequest[] public loanRequests;

    event LoanRequestCreated(uint256 requestId, address borrower);
    event LoanRequestApproved(uint256 requestId);
    event LoanRequestRejected(uint256 requestId);
    event LoanRequestCancelled(uint256 requestId, address borrower);

    function createLoanRequest(uint256 _amount, uint256 _tenure, uint256 _interestRate) external {
        LoanRequest memory newRequest = LoanRequest({
            amount: _amount,
            tenure: _tenure,
            interestRate: _interestRate,
            borrower: msg.sender,
            status: RequestStatus.Pending
        });

        loanRequests.push(newRequest);
        emit LoanRequestCreated(loanRequests.length - 1, msg.sender);
    }

    function approveLoanRequest(uint256 requestId) external {
        require(requestId < loanRequests.length, "Invalid request ID");
        require(loanRequests[requestId].status == RequestStatus.Pending, "Request is not pending");

        loanRequests[requestId].status = RequestStatus.Approved;
        emit LoanRequestApproved(requestId);
    }

    function rejectLoanRequest(uint256 requestId) external {
        require(requestId < loanRequests.length, "Invalid request ID");
        require(loanRequests[requestId].status == RequestStatus.Pending, "Request is not pending");

        loanRequests[requestId].status = RequestStatus.Rejected;
        emit LoanRequestRejected(requestId);
    }

    function cancelLoanRequest(uint256 requestId) external {
        require(requestId < loanRequests.length, "Invalid request ID");
        require(loanRequests[requestId].borrower == msg.sender, "You are not the borrower");
        require(loanRequests[requestId].status == RequestStatus.Pending, "Request is not pending");

        loanRequests[requestId].status = RequestStatus.Cancelled;
        emit LoanRequestCancelled(requestId, msg.sender);
    }

    function getLoanRequest(uint256 requestId) external view returns (
        uint256 amount,
        uint256 tenure,
        uint256 interestRate,
        address borrower,
        RequestStatus status
    ) {
        require(requestId < loanRequests.length, "Invalid request ID");
        LoanRequest memory request = loanRequests[requestId];
        return (
            request.amount,
            request.tenure,
            request.interestRate,
            request.borrower,
            request.status
        );
    }
}
