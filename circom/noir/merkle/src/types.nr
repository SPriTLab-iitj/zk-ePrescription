pub struct MerklePath<let PATH_LEN: u32> {
    pub hashes: [Field; PATH_LEN],
    pub dirs: [u8; PATH_LEN],
}
