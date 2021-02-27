// 这是一个netlify function
// 通过获取最新的release下载链接，来动态地重定向至在overleaf中打开
const https = require("https");

// HTTPS GET请求，返回body的JSON对象
const get = (url) =>
  new Promise((resolve, reject) => {
    https
      .get(url, { headers: { "User-Agent": "Mozilla/5.0" } }, (res) => {
        let body = "";
        res.on("data", (chunk) => {
          body += chunk;
        });
        res.on("end", () => {
          let r;
          try {
            r = JSON.parse(body);
          } catch {
            r = body;
          }
          resolve(r);
        });
      })
      .on("error", reject)
      .end();
  });

// 从shields.io的API中来获取最新的版本信息 https://shields.io/#like-this
// （从GitHub API获取包括prerelease在内的所有release有点太耗时了）
const hitShields = async ({ user, repo, prerelease }) => {
  const { value } = await get(
    `https://img.shields.io/github/v/release/${user}/${repo}.json${
      prerelease ? "?include_prereleases" : ""
    }`
  );
  if (value === "no releases or repo not found") {
    throw value;
  }
  return value;
};

exports.handler = async ({ queryStringParameters: { prerelease, bare } }) => {
  try {
    const user = "OopsYao";
    const repo = "swufethesis";
    const release = await hitShields({
      user,
      repo,
      prerelease: prerelease !== undefined,
    });
    const githubAsset = `https://github.com/${user}/${repo}/releases/download/${release}/swufethesis-${
      bare !== undefined ? "demo" : "portable"
    }-${release}.zip`;
    return {
      statusCode: 302,
      headers: {
        // Overleaf API https://www.overleaf.com/devs/
        Location: `https://www.overleaf.com/docs?snip_uri=${githubAsset}`,
      },
    };
  } catch (err) {
    return {
      statusCode: 404,
      body: err,
    };
  }
};
