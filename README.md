# Potion Unlock Smart Contracts Interfaces

## Summary

The **Potion Unlock** game defines the following items:

-   There is an **Unlock Key**, which is the final key that can be used to unlock the protocol. This key is
    private and cannot be accessed directly
-   There is a **Secret** that is assigned to the NFT contract. This **Secret** can be used to
    unlock the protocol during the validation phase
-   The NFTs in the contract are assigned a **Rarity**, that specifies how rare they are. Each rarity is assigned a range of NFT Token IDs and a range of the **Secret**, called the **Secret Segment**.
-   Then each NFT in the contract is assigned a piece of the **Secret** according to its rarity. This **Secret Piece** can be later used to validate the NFT and reveal the **Unlock Key**
-   The **Secret Piece** assigned to the NFT may not be unique. Depending of its rarity, several
    NFTs may share the same piece. This is called the **Secret Piece Redundancy**, and is a factor that
    is linked to the rarity of the NFT.

## Rarity Classes

**Potion Unlock** will release 10000 NFTs divided among the following rarity classes:

-   _Wise Wizard_, rarity ID 0
-   _Kelly Knight_, rarity ID 1
-   _OG_, rarity ID 2
-   _Fellow_, rarity ID 3
-   _Advanced_, rarity ID 4
-   _Legendary_, rarity ID 5

## Rarity Configuration

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

You can find the current rarity configuration for the Potion Unlock game in the file _RARITY_CONFIG.json_

## Contracts

There are 2 main contracts involved in the **Potion Unlock** game:

-   **NFTPotion** an ERC721 contract with auctioning capabilities. It allows to purchase NFTs of a certain rarity at a certain price. Each NFT is assigned a **Secret Piece** that can be validated in the **Validator** contract

-   **NFTPotionValidator** is the contract that handles the **Secret Piece** validation and publishes the verified **Unlock Key Pieces**

Check the attached interfaces for more information on the available functions, events and structures.
