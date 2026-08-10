pub mod types;
pub mod hash;
pub mod builder;
pub mod auth_path;
pub mod circuit;
pub mod verifier;

// Later:
// pub mod utils;

pub use types::MerklePath;
pub use hash::hash_node;
pub use builder::build_tree;
pub use auth_path::extract_auth_path;
pub use circuit::dual_mux;
pub use verifier::verify_path;
