# Retrieve certs automatically if possible
auto-key-locate cert pka

# Prevent boilerplate about needing key decryption, which is handled by the
# agent; the gpg function in my Bash scripts overrides this for certain
# commands where it interferes
batch

# Use SHA512 as the hash when making key signatures
cert-digest-algo SHA512

# Specify the hash algorithms to be used for new keys as available
default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed

# In the absence of any other recipient, encrypt messages for myself
default-recipient-self

# Show complete dates and use proper column separation for --with-colon listing mode
fixed-list-mode

# Use 16-character key IDs as the default 8-character key IDs can be forged
keyid-format 0xlong

# Use a pool of servers which support HKPS (encrypted key retrieval)
keyserver hkps://hkps.pool.sks-keyservers.net

# Retrieve keys automatically; check the keyserver port cert; use whichever
# server is proffered from the pool
keyserver-options auto-key-retrieve check-cert no-honor-keyserver-url ca-certfile=DOTFILES_HOME/.gnupg/sks-keyservers.net/sks-keyservers.netCA.pem

# Include trust/validity for UIDs in listings
list-options show-uid-validity

# Suppress the copyright message
no-greeting

# Use SHA512 as my message digest, overriding GnuPG's efforts to use the lowest
# common denominator in hashing algorithms
personal-digest-preferences SHA512

# Suppress a lot of output; sometimes I add --verbose to undo this
quiet

# Use the GPG agent for key management and decryption
use-agent

# Include trust/validity for UIDs when verifying signatures
verify-options pka-lookups show-uid-validity

# Assume "yes" is the answer to most questions, that is, don't keep asking me
# to confirm something I've asked to be done
yes

