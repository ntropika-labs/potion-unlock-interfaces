// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/**
    The NFT contract is an ERC721 contract with auctioning capabilities. The auction interface
    is priviledged only to the owner of the contract. The Potion Unlock game defines the following
    items:

    - There is an Unlock Key, which is the final key that can be used to unlock the protocol. This key is
      private and cannot be accessed directly
    - There is a Secret that is assigned to the NFT contract. This Secret can be used to
      unlock the protocol during the validation phase
    - The NFTs in the contract are assigned a rarity, that specifies how rare they are. Each rarity is assigned
      a range of NFT Token IDs and a range of the Secret, called the Secret Segment.
    - Then each NFT in the contract is assigned a piece of the Secret according to its rarity. This Secret Piece
      can be later used to validate the NFT and reveal the Unlock Key
    - The Secret Piece assigned to the NFT may not be unique. Depending of its rarity, several
      NFTs may share the same piece. This is called the Secret Piece Redundancy, and is a factor that
      is linked to the rarity of the NFT.
    
    The current planned Potion Unlock will release 10000 NFTs divided among the following rarity classes:
    
    - Wise Wizard, rarity number 0
    - Kelly Knight, rarity number 1
    - OG, rarity number 2
    - Fellow, rarity number 3
    - Advanced, rarity number 4
    - Legendary, rarity number 5

    Each rarity is given a specific rarity configuration that determines the length of the
    Secret Segment assigned to that rarity. It also specifies the length of each Secret Piece
    inside the Secret Segment, and which NFT token IDs are assigned to the rarity. The number
    of NFT tokens assigned to the rarity, the length of the Secret Segment, and the length of
    each Secret Piece will determine the redundancy of each Secret Piece inside the rarity,
    according to the following formula:

       Redundancy = (Number NFT Tokens) / (Secret Segment Length / Secret Piece Length)

    All Secret Pieces are non-overlapping. This particularly means that a Secret Piece can be uniquely
    identified by its position in the Secret. This is, there is only one Secret Piece that starts at
    the Secret position 1234, for example.
 */
interface NFTPotion {
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
        address indexed buyer,          // Address of the buyer
        uint32 indexed startTokenId,    // First token ID purchased
        uint32 amount,                  // Amount of tokens purchased
        uint256 limitPrice,             // Maximum price the buyer was willing to pay
        string publicKey                // Public key of the buyer for the unlock mechanism
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
    function rarityConfig(uint256 rarityId) external view returns (RarityConfigItem memory rarityConfigItem);

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
