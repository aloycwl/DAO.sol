// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {Check} from "https://github.com/aloycwl/Util.sol/blob/main/Security/Check.sol";

contract Node is Check {

    event Transfer(address indexed, address indexed, uint);
    event Vote(uint indexed, uint);
    bytes32 constant private EVO = 0x33952ef907843fd2ddd118a92dd935debf65b72965a557a364ea08deffca032f;
    
    function games(address adr) external view returns(bool stt, uint amt) {
        assembly {
            stt := sload(shl(0x05, adr))
            amt := sload(shl(0x06, adr))
        }
    }

    function checkVoting(uint ind) external view returns(uint, address, bytes32[5] memory, address) { 
        assembly {
            mstore(0x00, ind)
            let ptr := keccak256(0x00, 0x20)
            for { let i } lt(i, 0x08) { i := add(i, 0x01) } {
                mstore(add(0x80, mul(i, 0x20)), sload(add(ptr, i)))
            }
            return(0x80, 0x0100)
        }
    }

    function count() external view returns(uint cnt) {
        assembly { cnt := sload(INF) }
    }

    function topUp(address adr, uint amt) external {
        assembly {
            mstore(0x80, TFM)
            mstore(0x84, caller()) 
            mstore(0xa4, address())
            mstore(0xc4, amt)
            if iszero(call(gas(), sload(TTF), 0x00, 0x80, 0x64, 0x00, 0x00)) {
                mstore(0x80, ERR) 
                mstore(0xa0, STR)
                mstore(0xc0, ER2)
                revert(0x80, 0x64)
            }

            let tmp := shl(0x06, adr)
            sstore(tmp, add(sload(tmp), amt))
        }
    }

    function resourceOut(uint amt, uint8 v, bytes32 r, bytes32 s) external {
        _transfer(msg.sender, amt);
        isVRS(amt, v, r, s);
    }

    function resourceIn(address adr, uint amt) external {
        assembly { 
            if iszero(sload(shl(0x05, adr))) {
                mstore(0x80, ERR) 
                mstore(0xa0, STR)
                mstore(0xc0, ER1)
                revert(0x80, 0x64)
            }

            mstore(0x00, amt)
            log3(0x00, 0x20, ETF, caller(), adr) 

            mstore(0x80, TFM)
            mstore(0x84, caller()) 
            mstore(0xa4, address())
            mstore(0xc4, amt)
            if iszero(call(gas(), sload(TTF), 0x00, 0x80, 0x64, 0x00, 0x00)) {
                mstore(0x80, ERR) 
                mstore(0xa0, STR)
                mstore(0xc0, ER2)
                revert(0x80, 0x64)
            }
        }
    }

    function createVote(address adr, uint stt) external returns(uint cnt) {
        assembly {
            mstore(0x00, TP5)
            mstore(0x04, caller())
            pop(staticcall(gas(), sload(TP5), 0x00, 0x24, 0x00, 0x40))
            let nod := mload(0x20)
            if iszero(nod) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER1)
                revert(0x80, 0x64)
            }

            cnt := add(sload(INF), 0x01)
            sstore(INF, cnt)

            mstore(0x00, cnt)
            let ptr := keccak256(0x00, 0x20)
            sstore(ptr, stt)
            sstore(add(ptr, 0x01), adr)
            sstore(add(ptr, 0x07), caller())
            sstore(add(ptr, 0x08), nod)

            if gt(stt, 0x03) { stt := 0x03 }
            mstore(0x00, stt)
            log2(0x00, 0x20, EVO, cnt)
        }
    }

    function cancelVote(uint cnt) external {
        assembly {
            mstore(0x00, cnt)
            let ptr := keccak256(0x00, 0x20)
            if iszero(eq(sload(add(ptr, 0x07)), caller())) {
                mstore(0x80, ERR) 
                mstore(0xa0, STR)
                mstore(0xc0, ER1)
                revert(0x80, 0x64)
            }
            sstore(ptr, 0x00)
            sstore(add(ptr, 0x07), 0x00)

            mstore(0x00, 0x00)
            log2(0x00, 0x20, EVO, cnt)
        }
    }

    function vote(uint ind, bool vot) external {
        address toa;
        uint amt;

        assembly {
            mstore(0x00, add(vot, 0x04))
            log2(0x00, 0x20, EVO, ind)

            mstore(0x00, ind)
            let ptr := keccak256(0x00, 0x20)
            let up
            let down

            mstore(0x00, TP5)
            mstore(0x04, caller())
            pop(staticcall(gas(), sload(TP5), 0x00, 0x24, 0x00, 0x40))
            if or(iszero(mload(0x00)), iszero(eq(mload(0x20), sload(add(ptr, 0x08))))) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER1)
                revert(0x80, 0x64)
            }

            let tmp
            for { let i := add(ptr, 0x02) } lt(i, add(ptr, 0x07)) { i := add(i, 0x01) } {
                let sli := sload(i)
                if iszero(sli) {
                    tmp := i
                    break
                }
                if gt(sli, 0x00) {
                    switch gt(sli, STR) 
                    case 1 { 
                        up := add(up, 0x01)
                        mstore(0x00, sli)
                        mstore8(0x00, 0x00)
                        sli := mload(0x00)
                    }
                    default { down := add(down, 0x01) }
                }
                if eq(sli, caller()) {
                    tmp := 0x00
                    break
                }
            }

            let sta := sload(ptr)
            if or(iszero(sta), iszero(tmp)) {
                mstore(0x80, ERR) 
                mstore(0xa0, STR)
                mstore(0xc0, ER1)
                revert(0x80, 0x64)
            }

            mstore(0x00, caller())
            mstore8(0x00, vot)
            sstore(tmp, mload(0x00))

            if or(eq(up, 0x02), eq(down, 0x02)) {
                switch vot
                case 0x00 { down := add(down, 0x01) }
                default { up := add(up, 0x01) }

                mstore(0x00, 0x07)

                if gt(up, 0x02) { 
                    mstore(0x00, 0x06)

                    switch gt(sta, 0x02)
                    case 1 {
                        toa := sload(add(ptr, 0x01))
                        amt := sta
                    }
                    default {
                        sstore(shl(0x05, sload(add(ptr, 0x01))), mod(sta, 0x02))
                    }
                }
                sstore(ptr, 0x00)
                log2(0x00, 0x20, EVO, ind)
            }
        }

        if(amt > 0x00) _transfer(toa, amt);
    }

    function _transfer(address toa, uint amt) private {
        assembly {
            mstore(0x80, TTF)
            mstore(0x84, toa)
            mstore(0xa4, amt)
            if iszero(call(gas(), sload(TTF), 0x00, 0x80, 0x44, 0x00, 0x00)) {
                mstore(0x80, ERR) 
                mstore(0xa0, STR)
                mstore(0xc0, ER5)
                revert(0x80, 0x64)
            }
        }
    }

}