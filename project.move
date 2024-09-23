module MyModule::VotingPlatform {
    use std::signer;
    struct Proposal has store, key, drop {
        proposal_id: u64,
        votes_for: u64,
        votes_against: u64,
        is_tallied: bool,
    }

    struct Voter has store, key, drop {
        has_voted: bool,
    }

    // Function to cast a vote
    public fun cast_vote(voter: &signer, proposal_id: u64, vote_for: bool) acquires Proposal, Voter {
        let address = signer::address_of(voter);

        // Ensure voter hasn't voted yet
        assert!(move_from<Voter>(address).has_voted == false, 1);

        // Update vote counts
        let proposal = borrow_global_mut<Proposal>(address);
        if (vote_for) {
            proposal.votes_for = proposal.votes_for + 1;
        } else {
            proposal.votes_against = proposal.votes_against + 1;
        };

        // Mark the voter as having voted
        move_to(voter, Voter { has_voted: true });
    }

    // Function to tally votes and mark proposal as tallied
    public fun tally_votes(account: &signer) acquires Proposal {
        let address = signer::address_of(account);
        let proposal = borrow_global_mut<Proposal>(address);
        
        // Ensure proposal has not already been tallied
        assert!(!proposal.is_tallied, 2);

        // Mark the proposal as tallied
        proposal.is_tallied = true;

        // Here, you could add logic to act on the result, such as executing the proposal if it passes
    }
}
