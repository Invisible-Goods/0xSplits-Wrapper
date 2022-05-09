const getTrustedForwarder = (networkName) => {
  if (networkName === "matic") {
    return "0x86C80a8aa58e0A4fa09A69624c31Ab2a6CAD56b8";
  } else if (networkName === "mumbai") {
    return "0x9399bb24dbb5c4b782c70c2969f58716ebbd6a3b";
  }
};

module.exports = getTrustedForwarder;
