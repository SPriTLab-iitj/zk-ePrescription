fn main(x: Field) {

    let bits: [bool; 254] = x.to_le_bits::<254>();

    let mut count = 0;

    for i in 0..254 {
        if bits[254 - i - 1] {
            count += 1;
        }
    }

    let _ = count;
}
