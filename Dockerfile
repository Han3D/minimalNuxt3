ARG NODE_IMAGE=oven/bun:1-alpine

# Use explicitly the the alpine version and also the linux/amd64 platform
FROM --platform=linux/amd64 $NODE_IMAGE AS base
WORKDIR /usr/src/app
# Install the necessary packages to prevent error during the build process
RUN apk --no-cache add openssh g++ make python3 git

FROM base AS install
RUN mkdir -p /temp
COPY package.json bun.lockb /temp/
RUN cd /temp && bun install --frozen-lockfile

FROM install AS prerelease
COPY --from=install /temp/node_modules node_modules
COPY . .

ENV NODE_ENV=production
RUN bun run build

FROM base AS release
# COPY --chown=bun:bun --from=install /temp/node_modules node_modules
COPY --chown=bun:bun --from=prerelease /usr/src/app/.output .

USER bun
ENV HOST 0.0.0.0
EXPOSE 3000
ENTRYPOINT [ "bun", "run", "server/index.mjs" ]