// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/**
    The NFT contract is an ERC721 contract with auctioning capabilities. The auction interface
    is privileged only to the owner of the contract. 
 */
interface INFTPotion is IERC721 {
    //-------------------------------------------------------
    // DATA TYPES
    //-------------------------------------------------------

    /**
        @notice Contains the configuration for a specific NFT rarity. This includes the
        NFT token ID range (start and end, both included), the segment of the secret
        associated with the rarity (secret segment start and length) and how many bytes
        of that secret segment are associated to each NFT token of this rarity (thus, the length
        of the secret piece)

        The specific secret piece associated to a specifig NFT token ID is calculated by
        sequentially assigning bytesPerPiece bytes from the secret segment to each NFT token
        ID starting at startTokenId. If the end of the secret segment is reached, then the
        segment is considered a circular buffer and the process starts again from the beginning
    */
    struct RarityConfigItem {
        uint32 startTokenId;
        uint32 endTokenId;
        uint32 secretSegmentStart;
        uint32 secretSegmentLength;
        uint32 bytesPerPiece;
    }

    /**
        Contains the info about a range of NFTs purchased by a buyer

        @param startTokenId The first token ID of the range
        @param amount The amount of tokens in the range
     */
    struct PurchasedRange {
        uint32 startTokenId;
        uint32 amount;
    }

    //-------------------------------------------------------
    // EVENTS
    //-------------------------------------------------------

    /**
        Emitted when a buyer purchases an NFT. It is emitted once for the whole
        range of NFTs purchased.
     */
    event NFTPurchased(
        address indexed buyer, // Address of the buyer
        uint32 indexed startTokenId, // First token ID purchased
        uint32 amount, // Amount of tokens purchased
        uint256 limitPrice, // Maximum price the buyer was willing to pay
        string publicKey // Public key of the buyer for the unlock mechanism
    );

    //-------------------------------------------------------
    // FUNCTIONS
    //-------------------------------------------------------

    /**
        @notice Retrieves the configuration for a specific NFT rarity

        @param rarityId The ID of the rarity to retrieve

        @return rarityConfigItem The configuration for the specified rarity

        @dev If the returned rarity has the bytesPerPiece field set to 0, then the configuration
        does not exist for the given rarityId
     */
    function rarityConfig(uint256 rarityId)
        external
        view
        returns (RarityConfigItem memory rarityConfigItem);

    /**
        @notice Calculates the position and length of the secret piece associated
        with the given token ID relative to the full secret

        @param tokenId ID of the token to get the fragment for

        @return start Position of the secret piece in the full secret
        @return length Length of the secret piece
        @return found Whether the position and length were found

        @dev The returned start value can bu used to uniquely identify the secret piece
        assigned to the given token ID
     */
    function getSecretPositionLength(uint256 tokenId)
        external
        view
        returns (
            uint256 start,
            uint256 length,
            bool found
        );
}
