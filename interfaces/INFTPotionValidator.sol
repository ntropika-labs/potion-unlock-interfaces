// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/**
    The Potion Unlock validator allows to validate NFTs from the Potion Unlock game. Once an NFT has been bought,
    the buyer will be given a Secret Piece. This Secret Piece can be decrypted through the Potion Unlock website
    to retrieve a piece of the Unlock Key. The owner of the NFT can send this Unlock Key Piece to the validator
    to validate the piece and make it public, thus adding to the completion of the Unlock Key.

    This contract does not incentivize the validation of the Unlock Key, but provides the necessary functions
    to allow for an external contract to implement such functionality.
*/
interface NFTPotionValidator {
    //-------------------------------------------------------
    // EVENTS
    //-------------------------------------------------------

    /**
        @notice Event emitted when a NFT is validated.

        @param owner The address of the owner of the NFT.
        @param tokenId The ID of the NFT that was validated.
        @param secretStartPos The start position of the Secret Piece in the Secret
        @param decryptedSecret The piece of the Unlock Key that was decrypted and published
     */
    event NFTValidated(address indexed owner, uint256 indexed tokenId, uint256 secretStartPos, bytes decryptedSecret);

    /**
        @notice Validates the piece of the Unlock Key agains the given Merkle proof

        @param tokenId The token ID of the NFT that is being validated
        @param decryptedSecret The piece of Unlock Key that is being validated
        @param proof The Merkle proof for the decrypted secret

        @dev The validate function does not check if a piece of the Unlock Key has already been validated,
        thus a piece of the Unlock Key can be validated multiple times.
        
        @dev An external contract can use INFTPotion.getSecretPositionLength() to get the start position of a
        Secret Piece, and use that start position as key to understand if that part of the Unlock Key has already
        been validated.
      */
    function validate(
        uint256 tokenId,
        bytes calldata decryptedSecret,
        bytes32[] calldata proof
    ) external;

    /**
        @notice Batch validation of multiple NFTs

        @param tokenIds List of token Ids to be validated
        @param decryptedSecrets List of decrypted secrets associated with the token Ids
        @param proofs List of merkle proofs for the decrypted secrets

        @dev It calls validate() for each tokenID in the input. See validate() for more details
      */
    function validateList(
        uint256[] calldata tokenIds,
        bytes[] calldata decryptedSecrets,
        bytes32[][] calldata proofs
    ) external;

    //--------------------
    // View functions
    //--------------------

    /**
        Returns the validation status for a list of token IDs

        @param tokenIds List of token Ids to get the status for

        @return status Validation status for each token ID indicating if the given token ID
        has been validated at least once
     */
    function getValidationStatus(uint256[] calldata tokenIds) external view returns (bool[] memory status);
}
