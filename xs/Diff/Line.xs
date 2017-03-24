MODULE = Git::Raw			PACKAGE = Git::Raw::Diff::Line

SV *
origin(self)
	Diff_Line self

	CODE:
		RETVAL = git_diff_line_origin_to_str(self -> origin);

	OUTPUT: RETVAL

SV *
old_lineno(self)
	Diff_Line self

	CODE:
		if (self -> old_lineno >= 0) {
			RETVAL = newSVuv(self -> old_lineno);
		}
		else {
			XSRETURN_UNDEF;
		}

	OUTPUT: RETVAL

SV *
new_lineno(self)
	Diff_Line self

	CODE:
		if (self -> new_lineno >= 0) {
			RETVAL = newSVuv(self -> new_lineno);
		}
		else {
			XSRETURN_UNDEF;
		}

	OUTPUT: RETVAL

SV *
content(self)
	Diff_Line self

	PREINIT:
		size_t content_len = 0;
		const char *content = NULL;

	CODE:
		content_len = self -> content_len;
		content = self -> content;

		while (
			content_len > 0
			&& (content[content_len-1] == '\r' || content[content_len-1] == '\n')
		) {
			content_len--;
		}

		# If content_len is 0, newSVpv tries to measure content length using strlen
		# which expects a NUL terminated string. But content is not NUL terminated.
		RETVAL = content_len > 0 ? newSVpv(content, content_len) : newSVpv("", 0);

	OUTPUT: RETVAL

void
DESTROY(self)
	SV *self

	CODE:
		SvREFCNT_dec(GIT_SV_TO_MAGIC(self));
